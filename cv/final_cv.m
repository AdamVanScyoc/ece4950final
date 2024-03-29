function rVal = final_cv(rotated)

    %im = imread('./board_sample1.png');
    cam = '';
    imaqreset();
    
    cam = webcam('HP USB Webcam');
    snapshot(cam);
    pause(1);
    while 1==1
        im = snapshot(cam);

        dims = size(im);
        rows = dims(1);
        cols = dims(2);
        builder_image = im;
        lowThreshold = 150;
        highThreshold = 30;
        varianceThreshold = 30;
        varianceStartThreshold = 80;
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
                    average = (red+blue+green)/3;
                    if average > varianceStartThreshold
                        if (variance < varianceThreshold)
                            if red > varianceStartThreshold + 20
                                builder_image(y,x,1) = 0;
                                builder_image(y,x,2) = 0;
                                builder_image(y,x,3) = 0;
                            else
                                builder_image(y,x,1) = im(y,x,1);
                                builder_image(y,x,2) = im(y,x,2);
                                builder_image(y,x,3) = im(y,x,3);
                            end
                        else
                            builder_image(y,x,1) = im(y,x,1);
                            builder_image(y,x,2) = im(y,x,2);
                            builder_image(y,x,3) = im(y,x,3);
                        end
                    else
                        builder_image(y,x,1) = im(y,x,1) + 20;
                        builder_image(y,x,2) = im(y,x,2) + 20;
                        builder_image(y,x,3) = im(y,x,3) + 20;
                    end
                end
            end
        end
        %thresholded_image = builder_image;
        binary_image = imbinarize(rgb2gray(builder_image));
        props = regionprops(binary_image);
        centroids = cat(1,props.Centroid);
        areas = cat(1,props.Area);
        numShapes = numel(props);
        MinAreaThreshold = 50;
        output_image = im;
        shapes = {};
        numGoodShapes = 0;
        if numShapes > 0
            for n =1:numShapes
                if areas(n) > MinAreaThreshold
                    numGoodShapes = numGoodShapes + 1;
                    desc = '';
                    currentShape = [0,0,0];
                    currentShape(1) = centroids(n,1);
                    currentShape(2) = centroids(n,2);
                    xcoord = round(centroids(n,1));
                    ycoord = round(centroids(n,2));
                    sample_y = ycoord;
                    if areas(n) > 400
                        sample_y = ycoord - 12;
                    end
                    if sample_y < 1
                        sample_y = 1;
                    end
                    %disp(sample_y);
                    red = uint64(im(sample_y,xcoord,1));
                    green = uint64(im(sample_y,xcoord,2));
                    blue = uint64(im(sample_y,xcoord,3));
                    if rotated == 1
                        if ycoord < 175
                            red = red + 25
                            green = green + 25
                            blue = blue + 25
                        end
                    end
                    bred = red*red;
                    bgreen = green*green;
                    bblue = blue*blue;
                    %output_image(ycoord,xcoord,1) = 0;
                    %output_image(ycoord,xcoord,2) = 255;
                    %output_image(ycoord,xcoord,3) = 255;
                    %desc = strcat(desc,',',int2str(xcoord),',',int2str(ycoord),',');
                    desc = strcat(desc,'(',int2str(red),',',int2str(green),',',int2str(blue),'),');
                    %if bblue - 5000 > bred && bblue - 5000 > bgreen
                    %    currentShape(3) = 1;
                    %    desc = strcat(desc,'blue');
                    %elseif bgreen - 000 > bred && (red + green + blue) < 10000
                    %if blue > red
                    variance1 = 0;
                    if blue > red
                        variance1 = blue-red;
                    else
                        variance1 = red-blue;
                    end
                    variance2 = 0;
                    if blue > green
                        variance2 = blue-green;
                    else
                        variance2 = green-blue;
                    end
                    variance = variance1 + variance2;
                    %if (red+green+blue) < 270 && red < 85
                    if red < 90
                        fprintf("%d %d %d - %d %d %d\n",red,green,blue,variance1,variance2,variance);
                        currentShape(3) = 2;
                        desc = strcat(desc,'green');
                    %elseif red - 40 > green && green < 110 || red < 130
                    elseif green < 115 || red < 135
                        currentShape(3) = 1;
                        desc = strcat(desc,'red');
                    else
                        currentShape(3) = 3;
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
                    output_image = insertShape(output_image,'circle',[centroids(n,1), sample_y, 1],'LineWidth',1);
                end
            end
        end
        rVal = shapes;
        %disp(convert_to_string(rVal));
        %btn2.UserData = shapes;
        %disp(size(shapes));
        imshow(output_image);
        imaqreset();
        fprintf('Num Shapes Found: %d\n',numGoodShapes);
        if numGoodShapes < 10
            break;
        else
            pause(1);
            imshow(builder_image);
        end
    end
    %title_txt = sprintf('Image %d',vid.FramesAcquired);
    %title(title_txt);
end