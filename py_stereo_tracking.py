import sys
from PyQt4 import QtGui, uic, QtCore

class MyWindow(QtGui.QMainWindow):
    def __init__(self):
        super(MyWindow, self).__init__()
        self.ui = uic.loadUi('tracking_window.ui', self)

        self.ui.hSpinBox.valueChanged.connect(self.hSpinBoxChanged)
        self.ui.sMinSpinBox.valueChanged.connect(self.sMinSpinBoxChanged)
        self.ui.vMinSpinBox.valueChanged.connect(self.vMinSpinBoxChanged)
        self.ui.vMaxSpinBox.valueChanged.connect(self.vMaxSpinBoxChanged)

        self.ui.hSlider.valueChanged.connect(self.hSliderChanged)
        self.ui.sMinSlider.valueChanged.connect(self.sMinSliderChanged)
        self.ui.vMinSlider.valueChanged.connect(self.vMinSliderChanged)
        self.ui.vMaxSlider.valueChanged.connect(self.vMaxSliderChanged)
        self.ui.show()

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

if __name__ == '__main__':
    app = QtGui.QApplication(sys.argv)
    window = MyWindow()
    sys.exit(app.exec_())


#    TODO
# Add callbacks


