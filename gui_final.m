classdef gui_final < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        ReadBoardButton            matlab.ui.control.Button
        DecodeQRButton             matlab.ui.control.Button
        StartButton                matlab.ui.control.Button
        UITable                    matlab.ui.control.Table
        InitialConfigurationLabel  matlab.ui.control.Label
        UITable_2                  matlab.ui.control.Table
        Label                      matlab.ui.control.Label
        FinalConfigurationLabel    matlab.ui.control.Label
        SolveTimeEditFieldLabel    matlab.ui.control.Label
        SolveTimeEditField         matlab.ui.control.NumericEditField
        Button                     matlab.ui.control.Button
        UIAxes                     matlab.ui.control.UIAxes
    end



    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %             imaqreset; % reset device configuration. helps release open device handles.
            %             
            %             % user inputs 
                         nmaxframes = 40000; % how many frames should be displayed during trial?
                         nframegrab = 1; % get every nth frame from the camera
            %             
            %             % create the video input object. specify the image format and size
                         vid = videoinput('winvideo', 1, 'MJPG_640x480'); % capture a RGB image of size 640x480 pixels
            %             
            %             % Set video input object properties for this application.
                         set(vid,'TriggerRepeat',Inf);
                         vid.FrameGrabInterval = nframegrab; % grab every nth frame from the device
            %             
            %             % Start acquiring frames.
                         start(vid);
            
            %setappdata(0,'vid',vid);
            %setappdata(0,'nmaxframes',nmaxframes);
        end

        % Button pushed function: DecodeQRButton
        function DecodeQRButtonPushed(app, event)
            % Requires https://repo1.maven.org/maven2/com/google/zxing/javase/3.3.0/javase-3.3.0.jar
            % and      https://repo1.maven.org/maven2/com/google/zxing/core/3.3.0/core-3.3.0.jar
            clear source;
            clear jimg;
            clear bitmap;
            clear wc; 
            
            import com.google.zxing.qrcode.*;
            import com.google.zxing.client.j2se.*;
            import com.google.zxing.*;
            import com.google.zxing.common.*;
            import com.google.zxing.Result.*;
            
            % fig = uifigure('Name', 'Gameboard GUI', 'Position',[5 200 220 620]);
            ui = uifigure();
            ax = uiaxes('Parent',ui);
            
            wc = webcam('HD WebCam');
            %preview(wc);
            
            message = '';
            %break;
            while strcmp(message, '') == 1
                im = snapshot(wc);
                imshow(im,'Parent',ax);
                
                jimg = im2java2d(im);
                source = BufferedImageLuminanceSource(jimg);
                bitmap = BinaryBitmap(HybridBinarizer(source));
                qr_reader = QRCodeReader;
            
                try
                    result = qr_reader.decode(bitmap);
                    %parsedResult = ResultParser.parseResult(result);
                    message = char(result.getText());
            %                     break;
                catch e
                    message = '';
                end
            end % while
            
            % title_txt = sprintf('Image %s',message);
            %             end
            msgbox(message);
            
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
            
        end
        
        % Button pushed function: Read Board
        function ReadButtonPushed(app, event)
            addpath './cv'
            firstData = final_cv();
            firstString = convert_to_string(firstData);
            % rotate 90 degrees now
            secondData = final_cv();
            % figure out the order of each
            %lace together the ordered data
            rmpath './cv'
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

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Location'; 'Color'};
            app.UITable.RowName = {};
            app.UITable.Position = [5 104 186 231];

            % Create InitialConfigurationLabel
            app.InitialConfigurationLabel = uilabel(app.UIFigure);
            app.InitialConfigurationLabel.Position = [42 343 111 15];
            app.InitialConfigurationLabel.Text = 'Initial Configuration';

            % Create UITable_2
            app.UITable_2 = uitable(app.UIFigure);
            app.UITable_2.ColumnName = {'Location'; 'Color'};
            app.UITable_2.RowName = {};
            app.UITable_2.Position = [207 104 186 231];

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

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end