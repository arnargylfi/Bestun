clear
addpath('..\')
xbound = [-2 3];
ybound = [-1 2];
ub = [xbound(2),ybound(2)];
lb = [xbound(1),ybound(1)];

%-----TEKUR U.Þ.B (N)*10 SEK og SVO 10 SEK FYRIR HVERT ITERATION Í FOR LOOPINU-----

N = 8; %CHOOSE NUMBER OF FUNCTION EVALUATIONS
% Generate random points
inputPoints = lhsdesign(N,2).*(ub-lb)+lb;
wrapped_f = @(row) exercise_1_function(inputPoints(row,:)); %til að geta gert vector evaluation á f
tic
Y = arrayfun(wrapped_f,1:N); %EVALUATE
toc
%% CREATE MODEL
c = 4;
close
%RADIAL BASIS FUNCTIONS
Phi = zeros(N);
for i = 1:N
    Phi(i,:) = Phi_calc(inputPoints(i,:), inputPoints,c);
end

    
lambda = Phi\Y';

% Evaluate the basis functions at grid points
besty = inf;

%% OPTIMIZE SURROGATE MODEL AND UPDATAE AND SO ON
S = @(x) Phi_calc(x,inputPoints,c)*lambda;
for i = 1:10
    [xmin,ymin] = ParticleSwarm(S,100,2.05,2,[xbound;ybound],1000);
    %EVALUATE rEAL FUNCTION At miNIMUM
    realY_min = exercise_1_function(xmin);
    %UPDATE SURROGATE BY ADDING THE REAL POINTS
    inputPoints = [inputPoints;xmin];
    Y = [Y,realY_min];
    %REPEAT PROCESS OF MODEL CREATION
    N = length(Y);
    Phi = zeros(N);
    if realY_min < besty
        besty = realY_min;
        bestx = xmin;
    end

    for i = 1:N
        Phi(i,:) = Phi_calc(inputPoints(i,:), inputPoints,c);
    end
    lambda = Phi\Y';


             %PLOTS
            plotmeshsize = 100;
            x1_plot = linspace(xbound(1),xbound(2),plotmeshsize);
            x2_plot = linspace(ybound(1),ybound(2),plotmeshsize);
            [X1_plot, X2_plot] = meshgrid(x1_plot, x2_plot);
            Y_model = zeros(plotmeshsize);
            for k = 1:length(x1_plot)
                for m = 1:length(x1_plot)
                    Y_model(k,m) = Phi_calc([x1_plot(k),x2_plot(m)], inputPoints,c)*lambda;
                end
            end
            surf(X1_plot, X2_plot, Y_model,'DisplayName','Model');
            alpha(0.5)
            xlabel('x1');
            ylabel('x2');
            zlabel('Y');
            hold on 
            plot3(inputPoints(:,1), inputPoints(:,2), Y', 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r','DisplayName','Training points');
            title('RBF model');
            plot3(xmin(1),xmin(2),ymin,'go','Markersize',10,'MarkerFaceColor','magenta','DisplayName','Surrogate minima')
            plot3(xmin(1),xmin(2),realY_min,'go','Markersize',10,'MarkerFaceColor','cyan','DisplayName','Real function value at surrogate minima')
            legend()
            %SET lÓÐRÉTTAR LÍNUR TIL AÐ SÝNA ERROR
            plot3([xmin(1) xmin(1)], [xmin(2) xmin(2)], [ymin realY_min], 'r', 'LineWidth', 1.5, 'HandleVisibility', 'off');
    error = rmse(ymin,realY_min);
    sprintf('Root mean square error at surrogate minima = %f, iteration = %d',error,i)
    fprintf('Minimum x_1,x_2 = %s, min y = %f\n', mat2str(bestx),besty);
    hold off
end







%%
function Phi = Phi_calc(x,samples,c)
    N = length(samples);
    Phi = zeros(1,N);
    for i = 1:N
        dist = norm(x-samples(i,:));
        Phi(i) = exp(-c*dist.^2);
    end
end




