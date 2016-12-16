#include "video_wrapper.h"
#include<opencv2/highgui/highgui.hpp>
#include <iostream>

int main(int argc, char *argv[]) {
  VideoWrapper vw = VideoWrapper(argv[1]);
  // set crop
  //
  // visualize image
  Mat current_frame, hsv_frame;

  Rect crop_rect(250,0 ,390, 480);
  vw.SetCrop(crop_rect);

  while (1)
  {
    current_frame = vw.GetFrame();
  	cv::cvtColor(current_frame, hsv_frame, cv::COLOR_BGR2HSV);
  
  	cv::Mat lower_red_hue_range;
    cv::inRange(hsv_frame, cv::Scalar(0, 100, 100), cv::Scalar(10, 255, 255), lower_red_hue_range);
 
  imshow("current_frame", lower_red_hue_range);
  waitKey(0);

  }

  return 0;
}
