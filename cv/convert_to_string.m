function rVal = convert_to_string(input)
    [num, blank] = size(input);
    %disp(num);
    %disp(blank);
    %disp(input);
    index_locs = [
        [240 370],
        [204 282],
        [130 220],
        [195 150],
        [232 56],
        [340 90],
        [430 90],
        [430 215],
        [430 330],
        [340 330]];
    rVal = 'XXXXXXXXXX';
    for i=1:num
        currentMat = cell2mat(input(i));
        %disp(currentMat);
        current_x = currentMat(1);
        current_y = currentMat(2);
        current_color = currentMat(3);
        current_min_dist = 1000;
        ideal_index = 1;
        for index=1:10
            current_index_x = index_locs(index,1);
            current_index_y = index_locs(index,2);
            dist = sqrt((current_x - current_index_x).^2+(current_y - current_index_y).^2);
            %fprintf('%d vs %d\n',dist,current_min_dist);
            %disp(dist + 'vs' + current_min_dist);
            if dist<current_min_dist
                ideal_index = index;
                current_min_dist = dist;
            end
        end
        %disp(current_color);
        if current_color == 1
            rVal(ideal_index) = 'R';
        elseif current_color == 2
            rVal(ideal_index) = 'G';
        elseif current_color == 3
            rVal(ideal_index) = 'Y';
        end
        %disp(currentX);
        %disp(currentY);
        %disp(currentColor);
    end
end