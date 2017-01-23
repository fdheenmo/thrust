#!/usr/bin/env python

import sys, os, signal
from PyQt4 import QtGui, uic, QtCore

from PyQt4.QtCore import SIGNAL
import rospy
import cv2
import numpy as np
from image_geometry import StereoCameraModel
from std_msgs.msg import String
from sensor_msgs.msg import Image
from geometry_msgs.msg import PoseStamped
from sensor_msgs.msg import CameraInfo
from cv_bridge import CvBridge, CvBridgeError
from IPython import embed
import numpy, scipy.io

class MyWindow(QtGui.QMainWindow):
    def __init__(self):
        super(MyWindow, self).__init__()

        rospy.init_node('tool_tracker', anonymous=True)

        self.bridge = CvBridge()

        # Create camera model for calculating 3d position
        self.cam_model = StereoCameraModel()
        msgL = rospy.wait_for_message("/stereo/left/camera_info",CameraInfo,1);
        msgR = rospy.wait_for_message("/stereo/right/camera_info",CameraInfo,1);
        self.cam_model.fromCameraInfo(msgL,msgR)

        # Set up subscribers for camera images
        self.image_r_sub = rospy.Subscriber("/stereo/right/image_rect_color",Image,self.image_r_callback)
        self.imageL_sub = rospy.Subscriber("/stereo/left/image_rect_color",Image,self.imageL_callback)
        self.pose_sub = rospy.Subscriber("/dvrk/PSM2/position_cartesian_current", PoseStamped, self.pose_callback)
        # Set up blank image for left camera to update
        self.imageL = np.zeros((1,1,3),np.uint8)

        # Setup GUI

        self.ui = uic.loadUi('tracking_window.ui', self)

        self.ui.hSpinBox.valueChanged.connect(self.hSpinBoxChanged)
        self.ui.sMinSpinBox.valueChanged.connect(self.sMinSpinBoxChanged)
        self.ui.vMinSpinBox.valueChanged.connect(self.vMinSpinBoxChanged)
        self.ui.vMaxSpinBox.valueChanged.connect(self.vMaxSpinBoxChanged)

        self.ui.hSlider.valueChanged.connect(self.hSliderChanged)
        self.ui.sMinSlider.valueChanged.connect(self.sMinSliderChanged)
        self.ui.vMinSlider.valueChanged.connect(self.vMinSliderChanged)
        self.ui.vMaxSlider.valueChanged.connect(self.vMaxSliderChanged)
        self.ui.startRecordingPushButton.clicked.connect(self.startRecordingCallback)
        self.ui.stopRecordingPushButton.clicked.connect(self.stopRecordingCallback)
        self.ui.exportPointsPushButton.clicked.connect(self.exportPointsCallback)
        self.ui.generateTransformPushButton.clicked.connect(self.generateTransformCallback)
        self.ui.saveTransformPushButton.clicked.connect(self.saveTransformCallback)
        self.ui.showSegmentedCheckBox.stateChanged.connect(self.showSegmentedCallback)

        self.connect(self, SIGNAL("updateLeft"), self.updateLeftSlot)
        self.connect(self, SIGNAL("updateRight"), self.updateRightSlot)

        self.ui.show()

        self.ui.hSlider.setValue(0);
        self.ui.sMinSlider.setValue(133);
        self.ui.vMinSlider.setValue(207);
        self.ui.vMaxSlider.setValue(255);

        self.ui.hSpinBox.setValue(0);
        self.ui.sMinSpinBox.setValue(133);
        self.ui.vMinSpinBox.setValue(207);
        self.ui.vMaxSpinBox.setValue(255);

        self.segmentedL_pub = rospy.Publisher('segmented_left', Image, queue_size=10)
        self.segmentedR_pub = rospy.Publisher('segmented_right', Image, queue_size=10)

        self.recorded_kinematic_positions = np.empty((0,3))
        self.recorded_stereo_positions = np.empty((0,3))

        self.counter = 0
        self.recording = False
        self.show_segmented = False

    def startRecordingCallback(self):
        self.ui.stopRecordingPushButton.setEnabled(True)
        self.ui.startRecordingPushButton.setEnabled(False)
        self.recording = True

    def stopRecordingCallback(self):
        self.ui.stopRecordingPushButton.setEnabled(False)
        self.recording = False
        self.ui.exportPointsPushButton.setEnabled(True)
        self.ui.generateTransformPushButton.setEnabled(True)

    def exportPointsCallback(self):
        scipy.io.savemat('recorded_data.mat',
                mdict={'recorded_stereo_positions':self.recorded_stereo_positions,
                    'recorded_kinematic_positions': self.recorded_kinematic_positions})
        print "file saved"

    def generateTransformCallback(self):
        pass
        print "gotta run horn's method"
        self.ui.generateTransformPushButton.setEnabled(False)
        self.ui.saveTransformPushButton.setEnabled(True)

    def saveTransformCallback(self):
        pass

    def showSegmentedCallback(self, state):
        if state:
            self.show_segmented = True
        else:
            self.show_segmented = False


    def hSliderChanged(self, val):
        self.ui.hSpinBox.setValue(val)

    def sMinSliderChanged(self, val):
        self.ui.sMinSpinBox.setValue(val)

    def vMinSliderChanged(self, val):
        self.ui.vMinSpinBox.setValue(val)

    def vMaxSliderChanged(self, val):
        self.ui.vMaxSpinBox.setValue(val)


    def hSpinBoxChanged(self, val):
        self.ui.hSlider.setValue(val)

    def sMinSpinBoxChanged(self, val):
        self.ui.sMinSlider.setValue(val)

    def vMinSpinBoxChanged(self, val):
        self.ui.vMinSlider.setValue(val)

    def vMaxSpinBoxChanged(self, val):
        self.ui.vMaxSlider.setValue(val)

    def get_centroid(self,maskImage):
        # With help from http://www.pyimagesearch.com/2015/09/14/ball-tracking-with-opencv/
        # find contours in the mask and initialize the current
        # (x, y) center of the ball
        cnts = cv2.findContours(maskImage.copy(), cv2.RETR_EXTERNAL,
        cv2.CHAIN_APPROX_SIMPLE)[-2]
        center = None

        # only proceed if at least one contour was found
        if len(cnts) > 0:
        # find the largest contour in the mask, then use
        # it to compute the minimum enclosing circle and
        # centroid
            c = max(cnts, key=cv2.contourArea)
            ((x, y), radius) = cv2.minEnclosingCircle(c)
            M = cv2.moments(c)
            center = (int(M["m10"] / M["m00"]), int(M["m01"] / M["m00"]))
            # only proceed if the radius meets a minimum size
            if radius > 3:
                return center
        # Otherwise return nonsense
        return None

    def segment(self,img):
        # Convert to HSV and mask colors

        h = self.ui.hSlider.value()
        sMin = self.ui.sMinSlider.value()
        vMin = self.ui.vMinSlider.value()
        vMax = self.ui.vMaxSlider.value()

        colorLower = (np.max((h-15,0)), sMin, vMin)
        colorUpper = (np.min((h+15,180)), 255, vMax)
        blurred = cv2.GaussianBlur(img, (5, 5), 0)
        hsv = cv2.cvtColor(blurred, cv2.COLOR_BGR2HSV)
        mask = cv2.inRange(hsv, colorLower, colorUpper )
        # Refine mask
        mask = cv2.erode(mask, None, iterations=2)
        mask = cv2.dilate(mask, None, iterations=2)
        return mask

    def pose_callback(self, data):
        # print "callback"
        self.current_position = data.pose.position
        # embed()


    def updateLeftSlot(self):
        cvImage = self.imageL
        height, width, byteValue = cvImage.shape
        byteValue = byteValue * width

        cv2.cvtColor(cvImage, cv2.COLOR_BGR2RGB, cvImage)

        local_image = QtGui.QImage(cvImage, width, height, 
                byteValue, QtGui.QImage.Format_RGB888)

        pixMap = QtGui.QPixmap(local_image)
        pixMap = pixMap.scaled(320, 240, QtCore.Qt.KeepAspectRatio)
        pixMapItem = QtGui.QGraphicsPixmapItem(pixMap)

        scene = QtGui.QGraphicsScene(self)
        scene.addItem(pixMapItem)
        self.ui.leftGraphicsView.setScene(scene)

    def updateRightSlot(self):

        if self.show_segmented:
            cvImage = self.segmentedL
            cv2.cvtColor(cvImage, cv2.COLOR_GRAY2RGB, cvImage)
        else:
            cvImage = self.imageR
            cv2.cvtColor(cvImage, cv2.COLOR_BGR2RGB, cvImage)


        height, width, byteValue = cvImage.shape
        byteValue = byteValue * width
        local_image = QtGui.QImage(cvImage, width, height, 
                byteValue, QtGui.QImage.Format_RGB888)

        pixMap = QtGui.QPixmap(local_image)
        pixMap = pixMap.scaled(320, 240, QtCore.Qt.KeepAspectRatio)
        pixMapItem = QtGui.QGraphicsPixmapItem(pixMap)

        scene = QtGui.QGraphicsScene(self)
        scene.addItem(pixMapItem)
        self.ui.rightGraphicsView.setScene(scene)

    def imageL_callback(self,data):
        try:
            self.imageL = self.bridge.imgmsg_to_cv2(data, "bgr8")
        except CvBridgeError as e:
            print "left not working"
            print e

        self.segmentedL = self.segment(self.imageL)
        convI = self.bridge.cv2_to_imgmsg(self.segmentedL, "mono8")
        self.segmentedL_pub.publish(convI)

        self.emit(SIGNAL("updateLeft"))


    def image_r_callback(self,data):
        try:
            self.imageR = self.bridge.imgmsg_to_cv2(data, "bgr8")
        except CvBridgeError as e:
            print "right not working"
            print e

        stored_position = self.current_position #todo verify sync

        self.segmentedR = self.segment(self.imageR)
        convI = self.bridge.cv2_to_imgmsg(self.segmentedR, "mono8")
        self.segmentedR_pub.publish(convI)

        self.emit(SIGNAL("updateRight"))

        centerL = self.get_centroid(self.segmentedL)
        centerR = self.get_centroid(self.segmentedR)

        # print centerL, centerR


        if(centerL != None and centerR != None and self.recording):
            # print(self.cam_model.projectPixelTo3d(centerL,centerL[0] - centerR[0]))
            a = (self.cam_model.projectPixelTo3d(centerL,centerL[0] - centerR[0]))

            self.recorded_stereo_positions = np.append(self.recorded_stereo_positions, 
                    np.array([[ a[0], a[1], a[2]]]), axis = 0)

            self.recorded_kinematic_positions = np.append(self.recorded_kinematic_positions, 
                    np.array([[ stored_position.x, stored_position.y, stored_position.z]]), axis = 0)
            # print self.recorded_kinematic_positions

            self.counter = self.counter + 1
            print self.counter

            if self.counter % 10 == 0:
                self.ui.capturedPairsLineEdit.setText(str(self.counter))

            if self.counter == 100:
                self.stopRecordingCallback()





if __name__ == '__main__':
    app = QtGui.QApplication(sys.argv)
    window = MyWindow()
    sys.exit(app.exec_())
