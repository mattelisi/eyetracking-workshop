function fix = fixpar(sac, pos)
% extract fixation location and duration 
%
% input:
%  sac(:,1:8)       Parameters 
%
%  [onset offset dur peakVel distance angDist ampl angAmpl]
%
% output:
% fix(:,1:5)
% 
% [start end pos_x pos_y duration]

if size(sac,1)>0
    fix = zeros(size(sac,1), 5);
    fix(1, 1:2) = [1 , sac(1,1)];
    for s = 2:size(sac,1)
        fix(s, 1:2) = [sac(s-1, 2), sac(s, 1)];
    end
    for f = 1:size(fix,1)
        fix(f, 3) = mean(pos(fix(f, 1):fix(f, 2), 1));
        fix(f, 4) = mean(pos(fix(f, 1):fix(f, 2), 2));
        fix(f, 5) = fix(f, 2) - fix(f, 1);
    end
else
    fix = [1, size(pos,1), mean(pos(:,1)), mean(pos(:,2)), size(pos,1)];
    warning('No saccades found.')
end
        