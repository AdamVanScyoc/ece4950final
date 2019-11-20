function rVal = convert_to_string(input)
    [num, blank] = size(input);
    %disp(num);
    %disp(blank);
    %disp(input);
    rVal = 'XXXXXXXXXX';
    for i=1:num
        currentMat = cell2mat(input(num));
        disp(currentMat);
        currentX = currentMat(1);
        currentY = currentMat(2);
        currentColor = currentMat(3);
        %disp(currentX);
        %disp(currentY);
        %disp(currentColor);
    end
    rVal = 0;
end