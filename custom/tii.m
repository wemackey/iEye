function tii()
%TII Summary of this function goes here
%   Detailed explanation goes here

iEye;
drawnow;

jFigPeer = get(handle(gcf),'JavaFrame');
jWindow = jFigPeer.fHG1Client.getWindow;
com.sun.awt.AWTUtilities.setWindowOpacity(jWindow,0.85)
end

