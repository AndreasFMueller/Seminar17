% GUI for Schwarzschild calculations by
% Sascha Jecklin, Hoschschule Rapperswil

function myui(solution, x0, parameter)
s = parameter;
N = 800;           %Steps
ss = 0.5;          %StepSize

% Create a figure and axes
f = figure('Visible','off');
update;

% Create sliders
rg = uicontrol(f,'Style', 'slider',...
    'Min',1,'Max',50,'Value',x0(2,1),...
    'Position', [400 10 120 20]);
addlistener(rg, 'Value', 'PostSet', @rgCallBack);

vel = uicontrol(f,'Style', 'slider',...
    'Min',0,'Max',0.03,'Value',0.004,...
    'Position', [400 48 120 20]);
addlistener(vel, 'Value', 'PostSet', @velCallBack);

steps = uicontrol(f,'Style', 'slider',...
    'Min',10,'Max',10000,'Value',N,...
    'Position', [20 340 120 20]);
addlistener(steps, 'Value', 'PostSet', @stepsCallBack);

stepSize = uicontrol(f,'Style', 'slider',...
    'Min',0.1,'Max',2,'Value',0.5,...
    'Position', [20 380 120 20]);
addlistener(stepSize, 'Value', 'PostSet', @stepSizeCallBack);

% Create push button
btn = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
    'Position', [20 20 50 20],...
    'Callback', 'cla'); %btnCallBack provisorium


% Add a text uicontrol to label the slider.
rgTxt = uicontrol('Style','text',...
    'Position',[520 10 30 20],...
    'String','rg');

rgVal = uicontrol('Style','text',...
    'Position',[400 35 120 15],...
    'String',num2str(roundn(x0(2,1),-4)));

velTxt = uicontrol('Style','text',...
    'Position',[520 48 40 20],...
    'String','velocity');

velVal = uicontrol('Style','text',...
    'Position',[400 73 120 15],...
    'String',num2str(roundn(x0(8,1),-6)));

stepSizeTxt = uicontrol('Style','text',...
    'Position',[140 385 55 15],...
    'String', 'Step Size');

stepSizeVal = uicontrol('Style','text',...
    'Position',[20 400 120 20],...
    'String',ss);

stepsTxt = uicontrol('Style','text',...
    'Position',[140 345 35 15],...
    'String', 'Step');

stepsVal = uicontrol('Style','text',...
    'Position',[20 360 120 20],...
    'String',N);



% Make figure visble after adding all components
f.Visible = 'on';


    function rgCallBack(hObj,event)
        x0(2,1) = get(event.AffectedObject,'Value');
        set(rgVal, 'String', num2str(roundn(x0(2,1),-2)));
        update
    end

    function velCallBack(hObj,event)
        x0(8,1) = get(event.AffectedObject,'Value');
        set(velVal, 'String', num2str(roundn(x0(8,1),-5)));
        update;
    end

    function stepsCallBack(hObj,event)
        N = floor(get(event.AffectedObject,'Value'));
        set(stepsVal, 'String', num2str(N));
        update;
    end

    function stepSizeCallBack(hObj,event)
        ss = roundn((get(event.AffectedObject,'Value')),-1);
        set(stepSizeVal, 'String', num2str(ss));
        update;
    end

%GUI update
    function update
        s=1 * (0:ss:N);
        hold off;
        x0 = mnormalize(x0);
        solution = geodesic(x0, s);
        polarplot(solution(:,5),solution(:,3))
        solution(size(solution,1),:)
        drawEventHorizon;
    end

%Eventhorizon circle 
    function drawEventHorizon
        hold;
        th = linspace(0,2*pi,50);
        r = 1;
        polarplot(th,r+zeros(size(th)));
    end
    
    function btnCallBack(hObj,event)
       figure;
       solution(size(solution,1),:)
       plot(solution(:,1),solution(:,2))
    end

end

