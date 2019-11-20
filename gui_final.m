classdef gui_final < matlab.apps.AppBase
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        ReadBoardButton            matlab.ui.control.Button
        DecodeQRButton             matlab.ui.control.Button
        StartButton                matlab.ui.control.Button
        UITableInitConfig          matlab.ui.control.Table
        InitialConfigurationLabel  matlab.ui.control.Label
        UITableFinalConfig          matlab.ui.control.Table
        Label                      matlab.ui.control.Label
        FinalConfigurationLabel    matlab.ui.control.Label
        SolveTimeEditFieldLabel    matlab.ui.control.Label
        SolveTimeEditField         matlab.ui.control.NumericEditField
        Button                     matlab.ui.control.Button
        UIAxes                     matlab.ui.control.UIAxes
        % init_config stores the initial configuration of the board
        % to be stored in the Initial Configuration table.
        init_config                string
        % final_config stores the final configuration of the board
        % as decoded from the QR code; stored in the Final Configuration
        % table.
        final_config               string
        positions
    end



    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %             imaqreset; % reset device configuration. helps release open device handles.
            %             
            %             % user inputs 
            %             nmaxframes = 40000; % how many frames should be displayed during trial?
            %             nframegrab = 1; % get every nth frame from the camera
            %             
            %             % create the video input object. specify the image format and size
            %             vid = videoinput('winvideo', 1, 'MJPG_640x480'); % capture a RGB image of size 640x480 pixels
            %             
            %             % Set video input object properties for this application.
            %             set(vid,'TriggerRepeat',Inf);
            %             vid.FrameGrabInterval = nframegrab; % grab every nth frame from the device
            %             
            %             % Start acquiring frames.
            %             start(vid);
            
            %setappdata(0,'vid',vid);
            %setappdata(0,'nmaxframes',nmaxframes);
            
            set_param('Final_Project_Controller/Read_LED', 'value', '0');
            set_param('Final_Project_Controller/Solve_LED', 'value', '0');
        end

        % Button pushed function: DecodeQRButton
        function DecodeQRButtonPushed(app, event)
            % Requires https://repo1.maven.org/maven2/com/google/zxing/javase/3.3.0/javase-3.3.0.jar
            % and      https://repo1.maven.org/maven2/com/google/zxing/core/3.3.0/core-3.3.0.jar
            clear source;
            clear jimg;
            clear bitmap;
            clear wc; 
            
            addpath('./shortest_path');
            
            import com.google.zxing.qrcode.*;
            import com.google.zxing.client.j2se.*;
            import com.google.zxing.*;
            import com.google.zxing.common.*;
            import com.google.zxing.Result.*;
            
            % fig = uifigure('Name', 'Gameboard GUI', 'Position',[5 200 220 620]);
            ui = uifigure();
            ax = uiaxes('Parent',ui);
            
            %wc = webcam('HD WebCam');
            %wc = webcam('HD USB Webcam');
            wc = webcam(1);            
            
            message = '';
            while strcmp(message, '') == 1
                im = snapshot(wc);
                imshow(im,'Parent',ax);
                
                jimg = im2java2d(im);
                source = BufferedImageLuminanceSource(jimg);
                bitmap = BinaryBitmap(HybridBinarizer(source));
                qr_reader = QRCodeReader;
            
                try
                    result = qr_reader.decode(bitmap);
                    message = char(result.getText());
                catch e
                    message = '';
                end
            end % while
            
            msgbox(message);
            app.final_config = message;
            a = [];
            for b = 1:length(message)
                a(b) = int32(b);
                if message(b) == 'B'
                    message(b) = 'Y';
                end
            end
            data = [num2cell(a); num2cell(message)]';
            app.UITableFinalConfig.Data = data;         
            
            clear source;
            clear jimg;
            clear bitmap;
            clear wc;            
            
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            % Program to do text to speech.
            defaultString = 'ka pah dia';
            caUserInput = char(defaultString); % Convert from cell to string.
            NET.addAssembly('System.Speech');
            obj = System.Speech.Synthesis.SpeechSynthesizer;
            obj.Volume = 100;
            Speak(obj, caUserInput);
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)

            
            % start timer
            tic
            
            % perform arm movements
            enact(app.positions)
            
              % update time edit box
            t = toc
            disp(t);
            app.SolveTimeEditField.Value = t;

        end
        
        % Button pushed function: Read Board
        function ReadButtonPushed(app, event)
            addpath './cv'
            %firstData = final_cv();
            disp('Rotate to 0');
            set_param('Final_Project_Controller/DC','value','0');
            pause(1);
            pause(1);
            disp('Take first photo');
            firstString = convert_to_string(final_cv(0));
            disp(firstString);
            pause(1);
            pause(1);
            disp('Rotate to 90');
            set_param('Final_Project_Controller/DC','value','90');
            pause(2);
            pause(2);
            disp('Take Second Photo & Rotate to 0');
            secondString = convert_to_string(final_cv(1));
            set_param('Final_Project_Controller/DC','value','0');
            disp('Merge Strings');
            for i=1:10
                if firstString(i) == 'X'
                    firstString(i) = secondString(i);
                end
            end
            disp(firstString);
            app.init_config = string(firstString);
            %set_param('Final_Project_Controller/DC','value','0');
            % figure out the order of each
            %lace together the ordered data
            rmpath './cv'
            
            % pre-compute quickest solution
            final_state = [];
            init_state = [];
%             if (app.final_config ~= '')
                qr_code_in = app.final_config;


                final_state = char(qr_code_in)
                init_state = char(app.init_config)
                
                % add Initial board configuration string to GUI table
                a = [];
                for b = 1:length(init_state)
                    a(b) = int32(b);
                end
                data = [num2cell(a); num2cell(init_state)]';
                app.UITableInitConfig.Data = data; 

                fprintf("FIRST %s\n",final_state);
                shortest_path = traverse(init_state,final_state);

                % convert string argument to number pairs representing
                % arm position
                app.positions = convert(shortest_path)
%             end % if (app.final_config != '')
            
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create ReadBoardButton
            app.ReadBoardButton = uibutton(app.UIFigure, 'push');
            app.ReadBoardButton.ButtonPushedFcn = createCallbackFcn(app, @ReadButtonPushed, true);
            app.ReadBoardButton.Icon = 'apoorvakapadia.jpg';
            app.ReadBoardButton.BackgroundColor = [1 0 0];
            app.ReadBoardButton.FontSize = 18;
            app.ReadBoardButton.FontWeight = 'bold';
            app.ReadBoardButton.Position = [25 378 146 81];
            app.ReadBoardButton.Text = 'Read Board';

            % Create DecodeQRButton
            app.DecodeQRButton = uibutton(app.UIFigure, 'push');
            app.DecodeQRButton.ButtonPushedFcn = createCallbackFcn(app, @DecodeQRButtonPushed, true);
            app.DecodeQRButton.Icon = 'apoorvakapadia.jpg';
            app.DecodeQRButton.BackgroundColor = [1 1 0];
            app.DecodeQRButton.FontSize = 18;
            app.DecodeQRButton.FontWeight = 'bold';
            app.DecodeQRButton.Position = [248 378 146 81];
            app.DecodeQRButton.Text = 'Decode QR';

            % Create StartButton
            app.StartButton = uibutton(app.UIFigure, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.Icon = 'apoorvakapadia.jpg';
            app.StartButton.BackgroundColor = [0 1 0];
            app.StartButton.FontSize = 18;
            app.StartButton.FontWeight = 'bold';
            app.StartButton.Position = [467 378 146 81];
            app.StartButton.Text = 'Start';

             % Create UITableInitConfig
            app.UITableInitConfig = uitable(app.UIFigure);
            app.UITableInitConfig.ColumnName = {'Location'; 'Color'};
            app.UITableInitConfig.RowName = {};
            app.UITableInitConfig.Position = [5 104 186 231];

            % Create InitialConfigurationLabel
            app.InitialConfigurationLabel = uilabel(app.UIFigure);
            app.InitialConfigurationLabel.Position = [42 343 111 15];
            app.InitialConfigurationLabel.Text = 'Initial Configuration';

            % Create UITableFinalConfig
            app.UITableFinalConfig = uitable(app.UIFigure);
            app.UITableFinalConfig.ColumnName = {'Location'; 'Color'};
            app.UITableFinalConfig.RowName = {};
            app.UITableFinalConfig.Position = [207 104 186 231];

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.Position = [450 285 25 15];
            app.Label.Text = '';

            % Create FinalConfigurationLabel
            app.FinalConfigurationLabel = uilabel(app.UIFigure);
            app.FinalConfigurationLabel.Position = [245 343 109 15];
            app.FinalConfigurationLabel.Text = 'Final Configuration';

            % Create SolveTimeEditFieldLabel
            app.SolveTimeEditFieldLabel = uilabel(app.UIFigure);
            app.SolveTimeEditFieldLabel.HorizontalAlignment = 'right';
            app.SolveTimeEditFieldLabel.Position = [271 68 66 15];
            app.SolveTimeEditFieldLabel.Text = 'Solve Time';

            % Create SolveTimeEditField
            app.SolveTimeEditField = uieditfield(app.UIFigure, 'numeric');
            app.SolveTimeEditField.Position = [254 34 100 22];

            % Create Button
            app.Button = uibutton(app.UIFigure, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Icon = 'apoorvakapadia.jpg';
            app.Button.Position = [25 11 157 94];
            app.Button.Text = '';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.Position = [392 34 249 301];
        end
    end

    methods (Access = public)

        % Construct app
        function app = gui_final

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            set_param('Final_Project_Controller/Read_LED', 'value', '0');
            set_param('Final_Project_Controller/Solve_LED', 'value', '0');
            
            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
