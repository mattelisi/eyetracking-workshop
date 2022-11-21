function[visual] = prepStim(scr, const)
%
% perceptual task with noise patches
%
% Set display parameters, colors, etc. etc. 
%

visual.ppd = va2pix(1,scr);   % pixel per degree

% colors
visual.black = BlackIndex(scr.main);
visual.white = WhiteIndex(scr.main);
visual.bgColor = round((visual.black + visual.white) / 2);     % background color
visual.fgColor = visual.black;

% coordinates
visual.scrCenter = [scr.centerX scr.centerY scr.centerX scr.centerY];

% fixation point
visual.fixCkRad = round(2.5*visual.ppd);      % fixation check radius
visual.fixCkCol = visual.black;      % fixation check color
visual.fixCol = 50;

% target
visual.tarSize = 101;
if mod(visual.tarSize,2) == 0
    visual.tarSize = visual.tarSize+1;
end
visual.res = 1*[visual.tarSize visual.tarSize];

% set priority of window activities to maximum
priorityLevel=MaxPriority(scr.main);
Priority(priorityLevel);


 