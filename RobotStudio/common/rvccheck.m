function rvccheck(verbose)
    
    if nargin == 0
        verbose = true;
    end
    
    % display current versions of MATLAB
    year = version('-release');
    if verbose
        fprintf('You are using:\n - MATLAB release %s\n', year);
    end
    
    % check how old it is
    today = datevec(now);
    age =  today(1) - str2num(year(1:4));
    if age >= 2
        fprintf('     ** this is at least %d years old, you may have issues\n', age);
    end
    
    % display versions of toolboxes (use unique RTB and MVTB functions)
    p = getpath('lspb');
    a = ver( p );
    rtb = ~isempty(a);
    
    p = getpath('idisp');
    a = ver( p );
    mvtb = ~isempty(a);
        
    if verbose
        if rtb
            if findstr(p, 'Add-Ons')
                where = 'mltbx install to Add-Ons';
            else
                if exist( fullfile(p, '.git'), 'dir' )
                    where = 'local (git clone) install';
                else
                    where = 'local (zip) install';
                end
            end
            fprintf(' - %s %s %s [%s]\n', a.Name, a.Version, a.Date, where);
            
        end

        if mvtb
            if findstr(p, 'Add-Ons')
                where = 'mltbx install to Add-Ons';
            else
                if exist( fullfile(p, '.git'), 'dir' )
                    where = 'local (git clone) install';
                else
                    where = 'local (zip) install';
                end
            end
            fprintf(' - %s %s %s [%s]\n', a.Name, a.Version, a.Date, where);
        end
    end
    
    % check for shadowed files
    k = 0;
    if rtb
        k = k + checkpath('rotx');
        k = k + checkpath('roty');
        k = k + checkpath('rotz');
        k = k + checkpath('angdiff');
    end
    if mvtb
        k = k + checkpath('im2col');
        k = k + checkpath('col2im');
        k = k + checkpath('angdiff');
    end
    
    if k > 0
        fprintf('Some Toolbox files are "shadowed" and will cause problems with the use of this toolbox\n');
        fprintf('Use path tool to move this Toolbox to the top of the path\n')
    end
end

function k = checkpath(funcname)
    
    funcpath = which(funcname); % find first instance in path
    k = 0;
    
    good = {'rvc', ...
        'robotics-toolbox-matlab', 'Robotics Toolbox for MATLAB', ...
        'machinevision-toolbox-matlab', 'Machine Vision Toolbox for MATLAB', ...
        'smtb', 'spatial-math', 'Spatial Math Toolbox for MATLAB'};
    if exist(funcname)
        if all( cellfun(@(x) isempty(strfind(funcpath, x)), good) )
            fprintf('** Toolbox function %s is shadowed by %s\n', funcname, which(funcname) );
            k = 1;
        end
    end
end

function p = getpath(funcname)
    funcpath = which(funcname);
    k = strfind( funcpath, [filesep funcname]);
    p = funcpath(1:k-1);
end