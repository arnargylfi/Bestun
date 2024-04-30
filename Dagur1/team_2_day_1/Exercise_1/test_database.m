clear all, close all, clc

% Reset the database
people('data.mat', 'reset');

% List the database contents (show that database is empty)
people('data.mat', 'list');

% Insert people into the database
people('data.mat', 'insert', 'John', 25, 'Anna', 17, 'Max',50);

% List the database contents
people('data.mat', 'list');

% Remove a person from the database
people('data.mat', 'remove', 'John', 25);

% List the database again to see the change
people('data.mat', 'list');

% Attempt to remove a non existing person from the database
people('data.mat', 'remove', 'Jack', 25);

% Attempt to insert a person already in the database 
people('data.mat', 'insert', 'Anna', 17);

% Attempt to insert a person using the wrong format 
people('data.mat', 'insert', 'Lisa', -10);

% List the database again
people('data.mat', 'list');