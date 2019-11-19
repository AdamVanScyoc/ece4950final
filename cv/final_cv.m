im = imread('./final_sample.jpg');

dims = size(im);
rows = dims(1);
cols = dims(2);
builder_image = im;
lowThreshold = 180;
highThreshold = 80;
varianceThreshold = 20;
%varianceThreshold = 5;
%disp(rows);
%disp(cols);
%disp(size(im));
for y=1:rows
    if y == rows/2
        % Receive data from UI to CV
        iterator_current = getappdata(0,'iterator_current');
        currentlySelected = getappdata(0,'currentlySelected');
    end
    for x=1:cols
        %disp(x);
        %disp(y);
        %disp(size(im));
        %disp('-------');
        red = im(y,x,1);
        green = im(y,x,2);
        blue = im(y,x,3);
        lowestVal = red;
        if green < lowestVal
            lowestVal = green;
        end
        if blue < lowestVal
            lowestVal = blue;
        end
        highestVal = red;
        if green > highestVal
            highestVal = green;
        end
        if blue > highestVal
            highestVal = blue;
        end
        %delta = max(red,green,blue);
        %delta = abs(red-green) + abs(red-blue) + abs(green-blue);
        if lowestVal > lowThreshold
            builder_image(y,x,1) = 0;
            builder_image(y,x,2) = 0;
            builder_image(y,x,3) = 0;
        elseif highestVal < highThreshold
            builder_image(y,x,1) = 0;
            builder_image(y,x,2) = 0;
            builder_image(y,x,3) = 0;
        else
            variance = abs(red-green) + abs(red-blue) + abs(green-blue);
            if (variance < varianceThreshold)
                builder_image(y,x,1) = 0;
                builder_image(y,x,2) = 0;
                builder_image(y,x,3) = 0;
            else
                builder_image(y,x,1) = im(y,x,1);
                builder_image(y,x,2) = im(y,x,2);
                builder_image(y,x,3) = im(y,x,3);
            end
        end
        %disp(im(y,x));
        %pause();
    end
end
thresholded_image = builder_image;
binary_image = imbinarize(rgb2gray(builder_image));
props = regionprops(binary_image);
centroids = cat(1,props.Centroid);
areas = cat(1,props.Area);
numShapes = numel(props);

MinAreaThreshold = 50;
output_image = im;
shapes = [];
if numShapes > 0
    for n =1:numShapes
        if areas(n) > MinAreaThreshold
            desc = '';
            currentShape = ['','','',''];
            currentShape(1) = centroids(n,1);
            currentShape(2) = centroids(n,2);
            xcoord = round(centroids(n,1));
            ycoord = round(centroids(n,2));
            red = uint64(im(ycoord,xcoord,1));
            green = uint64(im(ycoord,xcoord,2));
            blue = uint64(im(ycoord,xcoord,3));
            bred = red*red;
            bgreen = green*green;
            bblue = blue*blue;
            %output_image(ycoord,xcoord,1) = 0;
            %output_image(ycoord,xcoord,2) = 255;
            %output_image(ycoord,xcoord,3) = 255;
            %desc = strcat(desc,',',int2str(xcoord),',',int2str(ycoord),',');
            %desc = strcat(desc,'(',int2str(red),',',int2str(green),',',int2str(blue),'),');
            if bblue - 5000 > bred && bblue - 5000 > bgreen
                currentShape(3) = 1;
                desc = strcat(desc,'blue');
            elseif bgreen - 1000 > bred && (red + green + blue) < 300
                currentShape(3) = 2;
                desc = strcat(desc,'green');
            elseif bred - 10000 > bgreen
                currentShape(3) = 3;
                desc = strcat(desc,'red');
            else
                currentShape(3) = 4;
                desc = strcat(desc,'yellow');
            end
            %disp(desc);
            %disp(currentShape);
            shapes = [shapes; currentShape];
            %horzcat(shapes,currentShape);
            output_image = insertText(output_image, [(centroids(n,1)-25) (centroids(n,2)-50)], desc);
            %output_image = insertText(output_image, [(centroids(n,1)-25) (centroids(n,2)-50)], int2str(areas(n)));
            %output_image = insertShape(output_image,'rectangle',[(centroids(n,1)-25) (centroids(n,2)-25) 50 50],'Color','red');
            %output_image = insertShape(output_image,'rectangle',[(centroids(n,1)-25) (centroids(n,2)-25) 50 50]);
            output_image = insertShape(output_image,'circle',[centroids(n,1) centroids(n,2) 20],'LineWidth',2);
        end
    end
end
btn2.UserData = shapes;
%disp(size(shapes));
%figure(fig_image);
imshow(output_image);
title_txt = sprintf('Image %d',vid.FramesAcquired);
title(title_txt);