# Stereo Tracking for da Vinci surgical robot
Feroze Naina

## Installation
Clone repository and open directory in MATLAB

## Usage

Step 0: Start the da Vinci, run roslaunch dvrk_vtk_registration stereo_vision.launch 

Step 1: Record data
Run live_record.m to store files
Copy files from inside the timestamped folder

Step 3: Manually annotate images
Run annotate_images.m and click on the tip
Run verify_annotations.m to check if the annotations are correct. Else, start over.

Step 3: Compute the 3D transform
Run triangulate_points.m
compute_transform.m - does least squares computation to determine Tf between camera frame and robot frame
verify_transform.m - Projects the 3D point back into RL camera frames using Tf computed above

## TODO
- When computing transform, just use all the files in the folder which have same name and L,R,T suffixes.
- Add the displacement into the equation
- Validate transform
- Fix colorbalance
- Easier way to collect data.
- Modular way to annotate or retake annotations without discarding entire 
- correct position transform to include the displacement to tip

## DEMO
<iframe width="560" height="315" src="https://www.youtube.com/embed/FlU17NmXGSs" frameborder="0" allowfullscreen></iframe>
