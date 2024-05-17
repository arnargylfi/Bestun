clear
addpath('..\')
xbound = [-2 3];
ybound = [-1 2];

%-----TEKUR U.Þ.B (N)*10 SEK og SVO 10 SEK FYRIR HVERT ITERATION Í FOR LOOPINU-----

N = 8; %CHOOSE NUMBER OF FUNCTION EVALUATIONS
% Generate random points
inputPoints = LHS(N,[xbound;ybound]);
wrapped_f = @(row) exercise_1_function(inputPoints(row,:)); %til að geta gert vector evaluation á f
tic
Y = arrayfun(wrapped_f,1:N); %EVALUATE
toc
%% CREATE MODEL
close
basis = 4; %CHOOSE NUMBER OF BASIS FUNCTIONS (3 or 4 best skilst mér)
X = ones(N,1);
%QUADRATIC BASIS FUNCTIONS
for j = 1:basis
    X = [X,inputPoints(:,1).^j,inputPoints(:,2).^j];
end

lambda = X\Y';

% Evaluate the basis functions at grid points


%% OPTIMIZE SURROGATE MODEL AND UPDATAE AND SO ON
S = @(x) createBasisFunction(x,basis)*lambda;
for i = 1:10
    close
    [xmin,ymin] = ParticleSwarm(S,100,2.05,2,[xbound;ybound],1000);
    %EVALUATE rEAL FUNCTION At miNIMUM
    realY_min = exercise_1_function(xmin);
    %UPDATE SURROGATE BY ADDING THE REAL POINTS
    inputPoints = [inputPoints;xmin];
    Y = [Y,realY_min];
    %REPEAT PROCESS OF MODEL CREATION
    X = ones(N+i,1);
    for j = 1:basis
        X = [X,inputPoints(:,1).^j,inputPoints(:,2).^j]
    end
    lambda = X\Y';


             %PLOTS
            close
            plotmeshsize = 100;
            x1_plot = linspace(xbound(1),xbound(2),plotmeshsize);
            x2_plot = linspace(ybound(1),ybound(2),plotmeshsize);
            [X1_plot, X2_plot] = meshgrid(x1_plot, x2_plot);
            X_plot = ones(numel(X1_plot), 1);
            for j = 1:basis
                X_plot = [X_plot, X1_plot(:).^j, X2_plot(:).^j];
            end
            Y_model = X_plot*lambda;
            Y_model = reshape(Y_model, size(X1_plot));
            figure;
            surf(X1_plot, X2_plot, Y_model,'DisplayName','Model');
            alpha(0.5)
            xlabel('x1');
            ylabel('x2');
            zlabel('Y');
            hold on 
            plot3(inputPoints(:,1), inputPoints(:,2), Y', 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r','DisplayName','Training points');
            title('Linear Regression Prediction with Quadratic Basis Functions');
            plot3(xmin(1),xmin(2),ymin,'go','Markersize',10,'MarkerFaceColor','magenta','DisplayName','Surrogate minima')
            plot3(xmin(1),xmin(2),realY_min,'go','Markersize',10,'MarkerFaceColor','cyan','DisplayName','Real function value at surrogate minima')
            legend()
            %SET lÓÐRÉTTAR LÍNUR TIL AÐ SÝNA ERROR
            plot3([xmin(1) xmin(1)], [xmin(2) xmin(2)], [ymin realY_min], 'r', 'LineWidth', 1.5, 'HandleVisibility', 'off');
    error = rmse(ymin,realY_min);
    sprintf('Root mean square error at surrogate minima = %f',error)

end







%%
function basis_functions = createBasisFunction(x,basis)
    basis_functions = ones(1, 1 + 2 * basis); % 
    
    % Fill in the basis function values
    for j = 1:basis
        basis_functions(1 + 2*(j-1) + 1) = x(1).^j; % x1^j
        basis_functions(1 + 2*(j-1) + 2) = x(2).^j; % x2^j
    end
end




