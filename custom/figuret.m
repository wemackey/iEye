function figuret(nm)
%FIGURET Summary of this function goes here
%   Detailed explanation goes here

figure('Name',nm,'NumberTitle','off');
drawnow;

jFigPeer = get(handle(gcf),'JavaFrame');
jWindow = jFigPeer.fHG1Client.getWindow;
com.sun.awt.AWTUtilities.setWindowOpacity(jWindow,0.79)

end

