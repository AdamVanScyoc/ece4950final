function enact(updown)

set_param('Final_Project_Controller/Read_LED', 'value', '1');
set_param('Final_Project_Controller/Read_LED', 'value', '5');

MAGNET_ON = '1';
MAGNET_OFF = '0';

MIN_MOVEMENT = 19;
MAX_MOVEMENT = 346;

MIN_DELAY = 1.7;
MAX_DELAY = 2.7;
delay = 2.5;

LED_COUNT = 1;
set_param('Final_Project_Controller/Solve_LED', 'value', '1');

if (length(updown(:,1)) >= 1)
    for i = 1:length(updown(:,1))

        row = updown(i,:)
        
        [startangle, startdiameter] = indextoposition(row(1));
        [endangle, enddiameter] = indextoposition(row(2));
        
        startangle_as_num = str2double(startangle);
        endangle_as_num = str2double(endangle);
        
        delay = (abs(startangle_as_num - endangle_as_num) - MIN_MOVEMENT) / (MAX_MOVEMENT - MIN_MOVEMENT);
        
        delay = delay * (MAX_DELAY - MIN_DELAY) + MIN_DELAY

        % MAX MOVEMENT 346 degrees
        % MIN MOVEMENT 19 degrees
        
        % Move to pos1 & diameter1
        %   Delay
        % Turn on magnet
        %   Delay
        % Move to pos2 & diameter2
        %   Delay
        % Turn off magnet
        %   Delay
        
        LED_COUNT = floor(i/(length(updown(:,1))/3));
        LED_COUNT = LED_COUNT + 1;
        set_param('Final_Project_Controller/Solve_LED','value',num2str(LED_COUNT));
%         if (mod(i, length(updown(:,1)) / 3) == 0 | length(updown(:,1)) / 3 <= 1)
%             fprintf("Iteration %d of %d\n", i, length(updown(:,1)));
%             if (LED_COUNT ~= 5)
%                 LED_COUNT = LED_COUNT + 1;
%             end
%             
%             set_param('Final_Project_Controller/Solve_LED', 'value', num2str(LED_COUNT));
%         end

        fprintf("MOVE TO %s degrees : diameter %c\n", startangle, startdiameter);
        set_param('Final_Project_Controller/DC', 'value', startangle);
        set_param('Final_Project_Controller/Servo', 'value', startdiameter);
        pause(delay);

        fprintf("MAGNET ON\n");
        set_param('Final_Project_Controller/Magnet', 'value', MAGNET_ON);
        pause(delay);

        fprintf("MOVE TO %s degrees : diameter %c\n", endangle, enddiameter);
        set_param('Final_Project_Controller/DC', 'value', endangle);
        set_param('Final_Project_Controller/Servo', 'value', enddiameter);
        pause(delay);

        fprintf("MAGNET OFF\n\n");
        set_param('Final_Project_Controller/Magnet', 'value', MAGNET_OFF);
        pause(delay);
    end    
        set_param('Final_Project_Controller/DC', 'value', '0');
        set_param('Final_Project_Controller/Servo', 'value', '1');
        set_param('Final_Project_Controller/Solve_LED', 'value', '5');
end
end









