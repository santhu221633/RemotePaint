RemotePaint
===========

Using this application, you can draw on one device, it will render on both devices connected by same wifi.
Run the application on two devices, select one as master device and the other will be slave. 
Start drawing in master device, it will render in slave also.

Entire project is shared here. Just clone it and run the project.
Right now, the project targets iPhone device.

FLOW ->
Run the app on two devices, lets call one master and the other slave.
Upon opening the app, it will ask you to choose either master or slave.
So, slave acts as a display to whatever is being drawn on master device.

Uses GCDAsynSocket library to communicate between two devices and PaintView library to smoothly draw curves.





