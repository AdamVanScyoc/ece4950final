function enact(updown)

MAGNET_ON = '1';
MAGNET_OFF = '0';

for i = 1:length(updown)
    
    row = updown(i,:);
    [startangle, startdiameter] = indextoposition(row(1));
    [endangle, enddiameter] = indextoposition(row(2));
    % Move to pos1 & diameter1
    %   Delay
    % Turn on magnet
    %   Delay
    % Move to pos2 & diameter2
    %   Delay
    % Turn off magnet
    %   Delay
    
    fprintf("MOVE TO %s degrees : diameter %c\n", startangle, startdiameter);
%     set_param('Final_Project_Controller/DC', 'value', startangle);
%     set_param('Final_Project_Controller/Servo', 'value', startdiameter);
    pause(2);
       
    fprintf("MAGNET ON\n");
%     set_param('Final_Project_Controller/Magnet', 'value', MAGNET_ON);
    pause(2);
    
    fprintf("MOVE TO %s degrees : diameter %c\n", endangle, enddiameter);
%     set_param('Final_Project_Controller/DC', 'value', endangle);
%     set_param('Final_Project_Controller/Servo', 'value', enddiameter);
    pause(2);
    
    fprintf("MAGNET OFF\n\n");
%     set_param('Final_Project_Controller/Magnet', 'value', MAGNET_OFF);
    pause(2);
    

end









