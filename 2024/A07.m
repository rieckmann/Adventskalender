clc
clear all
close all

file = fileread('A07.txt');

%% preprocessing
data = string(splitlines(file));

%% actual code
adventdriver(@part1, data);

adventdriver(@part2, data); % 145149066700218 too low

function r = part1(data)

    r = 0;
    for i=1:numel(data)
        line=split(data(i),': ');
        result = double(line(1));
        values = double(split(line(2)));
        a = [add(values(1), values(2:end)), mult(values(1), values(2:end))];
        if any(isnan(a))
            disp('NaN');
        end
        if any(a == result)
            r = r + result;
        end
    end
    
    function a = add(left, right)
        if numel(right) == 0
            a = left;
        else
            a = [add(left + right(1),right(2:end)), mult(left + right(1),right(2:end))];
        end
    end

    function a = mult(left, right)
        if numel(right) == 0
            a = left;
        else
            a = [add(left * right(1),right(2:end)), mult(left * right(1),right(2:end))];
        end
    end

end

function r = part2(data)

    r = 0;
    for i=1:numel(data)
        line=split(data(i),': ');
        result = double(line(1));
        values = double(split(line(2)));       
        disp(i);
        % if result <= maxi(values(1), values(2:end)) && result >= mini(values(1), values(2:end))
            a = [add(values(1), values(2:end), result), mult(values(1), values(2:end), result), concat(values(1), values(2:end), result)];
            if any(a == result)
                r = r + result;
            end
        % end
    end

    % function a = mini(left,right)
    %     if numel(right) == 0
    %                 a = left;
    %     else
    %         a = min([left + right(1), left * right(1), str2double(sprintf('%d', left, right(1)))]);
    %         a = mini(a, right(2:end));
    %     end
    % end
    % 
    % function a = maxi(left,right)
    %     if numel(right) == 0
    %                 a = left;
    %     else
    %         a = max([left + right(1), left * right(1), str2double(sprintf('%d', left, right(1)))]);
    %         a = maxi(a, right(2:end));
    %     end
    % end
    
    function a = add(left, right, result)
        if numel(right) == 0
            a = left;
        else
            b = left + right(1);
            if b <= result
                a = [add(b,right(2:end), result), mult(b,right(2:end), result), concat(b,right(2:end), result)];
            else
                a = [];
            end
        end
    end

    function a = mult(left, right, result)
        if numel(right) == 0
            a = left;
        else
            b = left * right(1);
            if b <= result
                a = [add(b,right(2:end), result), mult(b,right(2:end), result), concat(b,right(2:end), result)];
            else
                a = [];
            end
        end
    end

    function a = concat(left, right, result)
        if numel(right) == 0
            a = left;
        else
            b = str2double(sprintf('%d', left, right(1)));
            if b <= result
                a = [add(b,right(2:end), result), mult(b,right(2:end), result), concat(b,right(2:end), result)];
            else
                a = [];
            end
        end
    end

end