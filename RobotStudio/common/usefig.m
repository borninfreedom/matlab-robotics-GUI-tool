%USEFIG	Named figure windows
%
% usefig('Foo') makes figure 'Foo' the current figure, if it doesn't 
% exist create it.
%
% h = usefig('Foo') as above, but returns the figure handle

function H = usefig(name)

	h = findobj('Name', name);
	if isempty(h),
		h = figure;
		set(h, 'Name', name);
	else
		figure(h);
	end

	if nargout > 0,
		H = h;
	end
