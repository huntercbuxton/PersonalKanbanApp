# PersonalKanbanApp

## summary

A kanban board for your personal workflows- self-improvement, school, domestic sundries, etc. 

## implementation notes 

This app uses a Core Data model with two main types: 'Task' and 'Epic'. Each Epic is connected to its assigned tasks by a 'to-many' relationship with delete rule 'cascade'; the inverse relationship is 'to-one' with delete rule 'nullify'.

The core data management is performed mainly by a singleton class named PersistenceManager.  The primary displays of Epics and Tasks for different sections of the workflow ('to-do', 'backlog', etc) implement an NSFetchedResultsController, while a few more specialized displays perform the fetching and display managementwith custom implementations of fetch requests and the core data stack.

The primary menu and display is constructed with a UIViewController subclass 'MainVC' embedded in a UINavigationController. The MainVC instance has two child views which serve as containers for the Menu and content view controllers, respectively. The view containing the menu is stationary, while the other adjusts its anchor constraints to hide and reveal the menu as needed.   

## upcoming features

