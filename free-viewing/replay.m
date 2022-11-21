%% start sample recording experiment


addpath('Functions/');

fname = input('\n\n>>>> Give a name for the recording session:  ','s');

% general parameters
const.TEST        = 0; 

% specific
imgfile = 'dog-bone.png';
view_length = 10; % secs

%
home;
  
% prepare screens
scr = prepScreen(const);

% prepare stimuli
visual = prepStim(scr, const);
        
%plot(x,y)
%image(imdata)
%colormap bone

%% replay
Screen('FillRect', scr.main,visual.bgColor);
%Screen('DrawTexture', scr.main, imageTexture);

x_l = x(1);
y_l = y(1);
for i = 2:length(x)
    x_l = [x_l; x(i); x(i)];
    y_l = [y_l; y(i); y(i)];
end
Screen('DrawLines', scr.main, [x_l';y_l'], 3, [255 0 0]);
Screen('DrawDots', scr.main, [x';y'], 3, [255 0 0]);
Screen(scr.main, 'Flip');
SitNWait;

Screen('DrawTexture', scr.main, imageTexture);
Screen('DrawLines', scr.main, [x_l';y_l'], 3, [255 0 0]);
Screen('DrawDots', scr.main, [x';y'], 3, [255 0 0]);
Screen(scr.main, 'Flip');
SitNWait;


% 
ShowCursor;
Screen('CloseAll');
