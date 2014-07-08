function text_handles = polarticks (spokes, keep_lines, handle) 
% text_handles = polarticks (spokes, keep_lines, handle) 
%
%   Polar Plots in Matlab are hard coded to have radii at 30 deg intervals and do not allow for 
%     easy adjustment of xtick intervals.  This function circumvents this issues by changing the
%     circumference tick intervals, labels, and dotted spokes on any previously-created polar plot. 
%
%   INPUTS:
%   spokes = number of equally spaced ticks (radii) around the circumference starting at 0deg. 
%            Must be an even integer. 
%   keep_lines = a vector of handles of plotted lines to keep on the polar plot.
%            Note that if these changes are made before plotting any lines, 
%            this vector can just be empty [].
%   handle = the polar plot figure handle (optional; default is gca)
%
%   OUTPUT:
%   text_handles = the handles for the ticklabels 
%
%   Lastly, the 'y-ticks' references are marked at the circumference and midpoints.
%
%   Example:  
%           p = polar ((pi/180) .* [0:45:360], [25 5 25 5 25 5 25 5 25]);	%here's your pre-established polarplot
%           h = polarticks(8, p);	%where 8 = 8 radii (therefore, every 45 deg)

% Danz, 140330
% adam.danz%gmail.com
% Copyright (c) 2014, Adam Danz
% All rights reserved.
% http://www.mathworks.com/matlabcentral/fileexchange/46087-polarticks-m

if nargin < 3 || isempty(handle)
    handle = gca; end

if mod(spokes,2) ~= 0
    error ('Number of spokes needs to be an even integer');  %'spokes' are actually diameters.
end
    

% remove dotted radii and tickmarks and lables (actuall, all text)
h = findall(handle,'type','line');          %get handles for all lines in polar plot
h(ismember(h,keep_lines))=[];               %remove handles of plotted lines
delete (h)
t = findall(handle,'type','text');          %get handles for all text in polar plot
delete (t)

% add my own tick marks  (this section is adapted from the actual polar.m code
        % plot spokes
        th = (1 : spokes/2) * 2 * pi / spokes;
        cst = cos(th);
        snt = sin(th);
        cs = [-cst; cst];
        sn = [-snt; snt];
        v = [get(handle, 'XLim') get(handle, 'YLim')];
        rmax = v(2);
        ls = get(handle, 'GridLineStyle');
        tc = get(handle, 'XColor');
        line(rmax * cs, rmax * sn, 'LineStyle', ls, 'Color', tc,  'LineWidth', 1, ...
            'HandleVisibility', 'off', 'Parent', handle);
        
         % annotate spokes in degrees
        rt = 1.1 * rmax;
        degint = 360/spokes;
        for i = 1 : length(th)
            t_hand1(i) = text(rt * cst(i), rt * snt(i), int2str(i * degint),...
                'HorizontalAlignment', 'center', ...
                'HandleVisibility', 'off', 'Parent', handle);
            if i == length(th)
                loc = int2str(0);
            else
                loc = int2str(180 + i * degint);
            end
            t_hand2(i) = text(-rt * cst(i), -rt * snt(i), loc, 'HorizontalAlignment', 'center', ...
                'HandleVisibility', 'off', 'Parent', handle);
        end
        
                % set view to 2-D
        view(handle, 2);
        % set axis limits
        axis(handle, rmax * [-1, 1, -1.15, 1.15]);
        
        % text handle outputs
        text_handles = [t_hand1, t_hand2];
        
        % add 'y axis' labels to polar plot  (labels will always be between last two xticks)
            %outter circumference y val
            tx1 = get(text_handles(spokes), 'Position');      %text position of last xtick marker
            tx2 = get(text_handles(spokes-1), 'Position');    %text position of 2nd-last xtick marker
            circloc = [((tx1(1)-tx2(1))/2)+tx2(1) , ((tx1(2)-tx2(2))/2)+tx2(2)];        %location of midline between these two points.
            xlimmax = max(get(gca, 'xlim'));
            a0  = ((xlimmax^2)/(1+(( circloc(2)/circloc(1))^2)))^(1/2);            %adjust for circumference
            b0 = (circloc(2)/circloc(1)) * a0;
            text (a0, b0, num2str(xlimmax), 'FontSize', 8);

            %add inner circumference and 1/2 point
            hold on
            polar(deg2rad([0:1:359]),repmat(ceil(xlimmax/2),[1,360]),'-.k');
            slope = circloc(2)/circloc(1);
            hyp = xlimmax/2;
            a = ((hyp^2)/(1+(slope^2)))^(1/2);
            b = slope*a;
            text(a,b,num2str(hyp),'FontSize', 8);
            hold off

        
end

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.