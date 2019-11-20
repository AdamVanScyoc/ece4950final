function path = traverse(startpos, endpos)
if (strcmp(startpos, endpos) == 0)
words = unique(perms(startpos),'rows');

fprintf("END POSITION IS: %s\n", endpos);

set_param('Final_Project_Controller/Read_LED', 'value', '0');
set_param('Final_Project_Controller/Solve_LED', 'value', '0');

adjmat = zeros(length(words),length(words));

LED_COUNT = 1;


set_param('Final_Project_Controller/Read_LED', 'value', '1');

for r = 1:length(words)
    for c = 1:length(words)
        if (are_neighbors(words(r,:),words(c,:)) == true)
            adjmat(r,c) = 1;
            adjmat(c,r) = 1;
        end
    end
    
    if (mod(r, length(words) / 3) == 0)
        fprintf("Iteration %d of %d\n", r, length(words));
        LED_COUNT = LED_COUNT + 1
        set_param('Final_Project_Controller/Read_LED', 'value', num2str(LED_COUNT));
    end
end


set_param('Final_Project_Controller/Read_LED', 'value', '5');

words = cellstr(words);
G = graph(adjmat, words);

% plot(G);

path = shortestpath(G, startpos, endpos);

else
    path = {};
end

end


