function newax = subgridaxes(ax, rfrac, cfrac)
%SUBGRID Divide axis in subaxes
%
% newax = subgridaxes(ax, nr, nc)
% newax = subgridaxes(ax, rfrac, cfrac)
%
% Input variables: 
%
%   ax:     array of axes handles, each will be sub-divided as indicated
%
%   nr:     number of rows to split each axis into
%
%   nc:     number of columns
%
%   rfrac:  vector of values, indicating fraction (when sum is normalized
%           to 1) of height used by each new axis (bottom to top)
%
%   cfrac:  vector of values summing, indicating fraction (when sum is
%           normalized to 1) of width used by each new axis (left to right)
%
% Output variables:
%
%   newax:  nr x nc x size(ax) array of axes handles to the new axes.
%           Arrays are arranged to match visual arrangement of axes, with
%           newax(1,1) indicating the top left corner subaxis within each
%           old axis; the trailing dimensions preserve the size of the
%           input array.

% Copyright 2012 Kelly Kearney


% Check input

p = inputParser;
p.addRequired('ax');
p.addRequired('rfrac', @(x) validateattributes(x, {'numeric'}, {'vector', 'positive'}));
p.addRequired('cfrac', @(x) validateattributes(x, {'numeric'}, {'vector', 'positive'}));
p.parse(ax, rfrac, cfrac);

ax    = p.Results.ax;
rfrac = p.Results.rfrac;
cfrac = p.Results.cfrac;

% Parse rfrac/cfrac as integers or fractions

if isscalar(rfrac) && floor(rfrac)==rfrac
    height = ones(1,rfrac)./rfrac;
else
    height = rfrac./sum(rfrac);
end

if isscalar(cfrac) && floor(cfrac)==cfrac
    width = ones(1,cfrac)./cfrac;
else
    width = cfrac./sum(cfrac);
end

% Calculate new axis locations and create axes

left = [0 cumsum(width(1:end-1))];
bott = [0 cumsum(height(1:end-1))];

nrow = length(height);
ncol = length(width);


% newax = cell(length(height), length(width));
if verLessThan('matlab', '8.4.0')
    newax = zeros(nrow, ncol, numel(ax));
    % [newax{:}] = deal(zeros(size(ax)));
else
    newax = gobjects(nrow, ncol, numel(ax));
    % [newax{:}] = deal(gobjects(size(ax)));
end

for iax = 1:numel(ax)
  
    axpos = get(ax(iax), 'position');
    hfig = get(ax(iax), 'parent');
    
    l = axpos(1) + left.*axpos(3);
    b = axpos(2) + bott.*axpos(4);    
    b = b(end:-1:1);
    
    w = axpos(3).*width;
    h = axpos(4).*height;
    h = h(end:-1:1);
    
    for ir = 1:nrow
        for ic = 1:ncol
            % newax{ir,ic}(iax) = axes('position', [l(ic) b(ir) w(ic) h(ir)], 'parent', hfig);
            newax(ir,ic,iax) = axes('position', [l(ic) b(ir) w(ic) h(ir)], 'parent', hfig);
        end
    end
    
    
%     w = axpos(3)/sz(2);
%     h = axpos(4)/sz(1);

%     for inew = 1:numel(left)
%         newax{inew}(iax) = axes('position', [l(inew) b(inew) w(inew) h(inew)]);
%     end
    delete(ax(iax));
    
end

newax = reshape(newax, [nrow ncol size(ax)]);




    
   