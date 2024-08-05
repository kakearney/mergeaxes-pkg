function newax = mergeaxes(ax)
%MERGEAXES Create new axis that occupies space of previous ones
%
% newax = mergeaxes(ax)
%
% Input variables:
%
%   ax:     array of axis handles.  These objects will be deleted.
%
% Output variables:
%
%   newax:  handle of new axis, locating the combined space of the input
%           axes.

% Copyright 2013 Kelly Kearney

set(ax, 'units', 'normalized');
pos = get(ax, 'position');
pos = cat(1, pos{:});

l = min(pos(:,1));
r = max(pos(:,1) + pos(:,3));
b = min(pos(:,2));
t = max(pos(:,2) + pos(:,4));

newpos = [l b r-l t-b];

delete(ax);
newax = axes('position', newpos);




