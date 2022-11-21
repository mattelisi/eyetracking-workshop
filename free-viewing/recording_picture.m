%% start sample recording experiment

clear all;  clear mex;  clear functions;
addpath('Functions/');

fname = input('\n\n>>>> Give a name for the recording session:  ','s');

% general parameters
const.TEST        = 0; 

% specific
imgfile = 'images\tour_small.jpg';
view_length = 15; % secs

%
home;
  
% prepare screens
scr = prepScreen(const);

% prepare stimuli
visual = prepStim(scr, const);

% initialize eyelink-connection
[el, err]=initEyelink(fname,visual,const,scr);
if err==el.TERMINATE_KEY
    return
end

%% start recording
% hide cursor 
if ~const.TEST
    HideCursor;
end
    
% preload important functions
% NOTE: adjusting timer with GetSecsTest
% has become superfluous in OSX
Screen('FillRect', scr.main,visual.bgColor);
Screen(scr.main, 'Flip');
WaitSecs(.2);

% 
Screen(scr.main,'DrawText','Press any key to start.',100,100,visual.fgColor);
Screen(scr.main, 'Flip');
SitNWait;

%
Eyelink('StartRecording');
WaitSecs(0.2);

% determine recorded eye
if ~isfield(const,'recEye') && ~const.TEST
    evt = Eyelink('newestfloatsample');
    const.recEye = find(evt.gx ~= -32768);
    %eye_used = Eyelink('EyeAvailable'); % get tracked eye 
    %const.recEye = Eyelink('EyeAvailable');
end

% tracker calibration
if ~const.TEST
    calibresult = EyelinkDoTrackerSetup(el);
    if calibresult==el.TERMINATE_KEY
        return
    end
end

    
% % CHECK FIXATION
% %if ~const.TEST
%     fix = 0;
% %else
% %    fix = 1;
% %end
% while fix~=1
%     
%     Eyelink('command','clear_screen 0');
%     cleanScr;
%     WaitSecs(0.1);
%     
%     fix = checkFix(scr, visual, const, [scr.centerX, scr.centerY]);
% end

%
Eyelink('StartRecording')
WaitSecs(0.1);

% show picture
imdata=imread(imgfile);
imageTexture=Screen('MakeTexture',scr.main, imdata);
Screen('FillRect', scr.main,visual.bgColor);
Screen('DrawTexture', scr.main, imageTexture);
Screen(scr.main, 'Flip');

Eyelink('message', 'PICTURE_ONSET');

%
WaitSecs(view_length);
% T_on = GetSecs;
% while (GetSecs-T_on) < view_length
%     [x,y] =getCoord(wPtr,const);
%     Screen('DrawTexture', scr.main, imageTexture);
%     Screen(scr.main,'FillOval',visual.fgColor,[x,y]+[-3 -3 3 3]);
%     Screen(scr.main, 'Flip');
% end

Screen('FillRect', scr.main,visual.bgColor);
Screen(scr.main,'DrawText','Merci!',100,100,visual.fgColor);
Screen(scr.main,'Flip');

Eyelink('message', 'PICTURE_OFFSET');

% end recording
Eyelink('stoprecording');

%% shut down everything
%reddUp;

% get eyelink data file on subject computer
%vpnr = vpcode((end-7):end);
%edffilename = strcat(vpnr,'.edf');
status = Eyelink('ReceiveFile');%,edffilename, edffilename, 'Data/');
if status == 0
    fprintf(1,'\n\nFile transfer was cancelled\n\n');
elseif status < 0
    fprintf(1,'\n\nError occurred during file transfer\n\n');
else
    fprintf(1,'\n\nFile has been transferred (%i Bytes)\n\n',status)
end

% Eyelink runterfahren
Eyelink('closefile');
WaitSecs(2.0); % Zeit fur Tracker, alles fertigzubekommen
Eyelink('shutdown');
WaitSecs(2.0);

%%

dos(sprintf('edf2asc -s -miss -1.0 %s.edf', fname ));
dos(sprintf('cat %s.asc | awk "{print $1 "," $2 "," $3 "," $4}"  > raw\\%s.dat', fname, fname));
%movefile(sprintf('%s.asc', fname), sprintf('raw\\%s.dat', fname));
delete(sprintf('%s.asc', fname ));

dos(sprintf('edf2asc -e %s.edf', fname ));
dos(sprintf("cat %s.asc | grep -E 'MSG' > raw\\%s.msg", fname, fname))
delete(sprintf('%s.asc', fname ));

msgfile = sprintf('raw/%s.msg',fname);
datfile = sprintf('raw/%s.dat',fname);

msgfid = fopen(msgfile ,'r');
times = [-1 -1];

while times(2)==-1
    line = fgetl(msgfid);
    la = strread(line,'%s');
    if strcmp(char(la(3)), 'PICTURE_ONSET')
        times(1) = str2double(char(la(2)));
    end
    if strcmp(char(la(3)), 'PICTURE_OFFSET')
        times(2) = str2double(char(la(2)));
    end
end
fclose(msgfid);

dat = load(datfile);
idxrs = find(dat(:,1)>=times(1) & dat(:,1)<=times(2));
x = dat(idxrs,2);	% x
y = dat(idxrs,3);	% x
            
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

%plot(x,y)

Screen('DrawTexture', scr.main, imageTexture);
Screen('DrawLines', scr.main, [x_l';y_l'], 3, [255 0 0]);
Screen('DrawDots', scr.main, [x';y'], 3, [255 0 0]);
Screen(scr.main, 'Flip');
SitNWait;


% 
ShowCursor;
Screen('CloseAll');
