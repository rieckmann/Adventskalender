clc
clear all
close all

file = fopen('A04.txt');
data = fread(file,[142,inf],'uchar=>char')'; % 142 columns (reading is transposed)
data = data(1:end,1:end-2); % exclude \r\n from the linebreak characters
fclose(file);

adventdriver(@part1, data);

adventdriver(@part2, data);

function r = part1(data)
    r = 0;
    r = r + findhorizontal(data,false);
    r = r + findhorizontal(data,true);
    r = r + findvertical(data,false);
    r = r + findvertical(data,true);
    r = r + finddiagonalforward(data,false);
    r = r + finddiagonalforward(data,true);
    r = r + finddiagonalbackward(data,false);
    r = r + finddiagonalbackward(data,true);
end

function r = part2(data)
    r = 0;
    
    n = 3;
    
    M = size(data,1)-n+1;  
    N = size(data,2)-n+1;    
    
    for i=1:M
        match = zeros(1,N);
        for j=1:N
            test = data(i:i-1+n,j:j-1+n);
            d1 = diag(test)';
            d2 = diag(flip(test))';
            match(j) = (all(d1 == 'MAS') || all(d1 == 'SAM')) && (all(d2 == 'MAS') || all(d2 == 'SAM'));
        end
        r = r + sum(match);
    end
end

function count = findhorizontal(data, reverse)

    if ~reverse
        pattern='XMAS';
    else
        pattern='SAMX';
    end
    
    N = size(data,2)-4+1;    
    count = 0;
    
    for i=1:size(data,1)
        match = zeros(1,N);
        for j=1:N
            match(j)=all(data(i,j:j-1+4) == pattern);
        end
        count = count + sum(match);
    end
end

function count = findvertical(data, reverse)
    if ~reverse
        pattern='XMAS';
        pattern=pattern';
    else
        pattern='SAMX';
        pattern=pattern';
    end
    
    N = size(data,1)-4+1;    
    count = 0;
    
    for i=1:size(data,2)
        match = zeros(N,1);
        for j=1:N
            match(j)=all(data(j:j-1+4,i) == pattern);
        end
        count = count + sum(match);
    end
end

function count = finddiagonalforward(data, reverse)
    if ~reverse
        pattern='XMAS';
    else
        pattern='SAMX';
    end
    
    M = size(data,1)-4+1;  
    N = size(data,2)-4+1;    
    count = 0;
    
    for i=1:M
        match = zeros(1,N);
        for j=1:N
            test = diag(flip(data(i:i-1+4,j:j-1+4)))';
            match(j) = all(test == pattern);
        end
        count = count + sum(match);
    end
end

function count = finddiagonalbackward(data, reverse)
    if ~reverse
        pattern='XMAS';
    else
        pattern='SAMX';
    end
    
    M = size(data,1)-4+1;  
    N = size(data,2)-4+1;    
    count = 0;
    
    for i=1:M
        match = zeros(1,N);
        for j=1:N
            test = diag(data(i:i-1+4,j:j-1+4))';
            match(j) = all(test == pattern);
        end
        count = count + sum(match);
    end
end