function enact(updown)

MAGNET_ON = '1';
MAGNET_OFF = '0';

for i = 1:length(updown)
    
    row = updown(i,:);
    
    % Move to pos1
    %   Delay
    % Turn on magnet
    %   Delay
    % Move to pos2
    %   Delay
    % Turn off magnet
    %   Delay
    
    fprintf("MOVE TO %d\n", row(1));
%     set_param('Final_Project_Controller/DC', 'value', row(1));
    pause(2);
       
    fprintf("MAGNET ON\n");
%     set_param('Final_Project_Controller/Magnet', 'value', MAGNET_ON);
    pause(2);
    
    fprintf("MOVE TO %d\n", row(2));
%     set_param('Final_Project_Controller/DC', 'value', row(2));
    pause(2);
    
    fprintf("MAGNET OFF\n\n");
%     set_param('Final_Project_Controller/Magnet', 'value', MAGNET_OFF);
    pause(2);
    

end









