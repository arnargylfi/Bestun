function people(db_file, operation, varargin)
    if nargin < 2
        error('Not enough input arguments.');
    end

    switch operation
        case 'reset'
            resetDatabase(db_file);
            disp('Database initialized')
        case 'list'
            listDatabase(db_file);
        case 'insert'
            if mod(length(varargin), 2) ~= 0
                error('Insert requires pairs of name and age.');
            end
            insertPeople(db_file, varargin);
        case 'remove'
            if mod(length(varargin), 2) ~= 0
                error('Remove requires pairs of name and age.');
            end
            removePeople(db_file, varargin);
        otherwise
            error('Unknown operation.');
    end
end

function resetDatabase(db_file)
    S = struct('name', {}, 'age', {});
    save(db_file, 'S');
end

function listDatabase(db_file)
    if exist(db_file, 'file')
        load(db_file, 'S');
        if isempty(S)
            disp('Database is empty.');
        else
            disp(' ----------------------- ')
            disp('    Database contents    ')
            disp(' ')
            
            for i = 1:length(S)
                fprintf('%s, %d\n', S(i).name, S(i).age);
            end
            disp('  ---------------------  ')
            disp(' ')
            
        end
    else
        disp('Database file not found.');
    end
end

function insertPeople(db_file, people)
    if exist(db_file, 'file')
        load(db_file, 'S');  % Load existing database
    else
        S = struct('name', {}, 'age', {});  % Create a new empty database structure if file doesn't exist
    end

    for i = 1:2:length(people)
        name = people{i};
        age = people{i+1};
        
        % Check if name is a string and age is a number and non-negative
        if ~ischar(name) || ~isnumeric(age) || age < 0
            fprintf('Invalid input for person: name must be a string and age must be a non-negative number. No insertion made for %s, %d.\n', name, age);
            continue;  
        end

        % Check if the person already exists in the database
        if any(strcmp({S.name}, name) & [S.age] == age)
            fprintf('Person %s, age %d already exists in the database. No insertion made.\n', name, age);
        else
            S(end+1) = struct('name', name, 'age', age);  % Add new person
        end
    end

    save(db_file, 'S'); 
end



function removePeople(db_file, people)
    if exist(db_file, 'file')
        load(db_file, 'S');
    else
        error('Database file not found.');
    end
    
    % Ensure there are entries to remove
    if isempty(S)
        disp('The database is currently empty. No entries to remove.');
    end

    for i = 1:2:length(people)
        name = people{i};
        age = people{i+1};
        idx = find(strcmp({S.name}, name) & [S.age] == age);
        
        if isempty(idx)
            fprintf('No entry found for %s, %d to remove.\n', name, age);
        end

        S(idx) = [];
    end

    save(db_file, 'S');
end

