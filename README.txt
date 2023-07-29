TITLE: Agent-Based Simulation Model of COVID-19 Epidemic to analyze its infection risks in National Center for Mental Health (NCMH) using the GAMA Platform

Author: Lyka Raquel C. Lim
Date: June 2023


Included: All source files used in the Experiment (.gaml file for the different scenarios and .shp file for buildings and road networks, all in the zip file named "Lim_Experiment"), All latex files in a zip folder named "LIM - CMSC 190 - Manuscript", and final paper in a pdf file named "LIM___CMSC_190___Final Paper".


The goal of this experiment is to execute and analyze a mathematical model to understand the behavior of COVID 19 disease inside the National Center for Mental Health in Mandaluyong city, Philippines. Different restrictions were implemented to analyze the effects it makes on the population. Please kindly note that this project was created for Educational Purposes only!
1. INSTALLATION
It is simple to install the GAMA platform on a computer running Windows, Mac OS, or Ubuntu. A number of additional plugins can then be used to expand GAMA. The most recent GAMA release (1.8.1) makes installation incredibly simple by offering a version with an embedded Java JDK and reducing the installation process to just three steps: download, extract, and launch.


* DOWNLOAD GAMA


GAMA 1.8.1, the most recent version, is available in 6 versions. Windows, MacOS X, and Linux (tested primarily on Ubuntu) each have two versions (by default in 64 bits), One version of each OS contains the Java JDK (1.8.0_161 in 64 bits), while the other does not. The earlier releases (GAMA 1.8RC2 and 1.7) featured 32-bit versions for Windows and Linux, but none of them included the Java JDK. You must first choose which version to use because the two versions' bit counts must match. This relies on your computer, which may or may not handle 64-bit instructions, as well as the version of Java that is already installed. Given that numerous problems have been resolved and numerous enhancements have been made, it is not advised that you utilize it. After downloading the desired GAMA version, all that is left to do is run GAMA by extracting the zip file to the desired location on your computer.


* INSTALL GAMA


The Oracle-distributed Java Virtual Machine, which has been tested on all platforms (http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html), is the one that is advised. Installing the JDK (Java Development Kit) rather than the JRE (Java Runtime Environment) is advised. The normal JRE might allow GAMA to run, but it will be slower and considerably more likely to crash (especially under MacOS X). 
   * On MAC OS X

The most recent version of GAMA can only be used with a JVM (or JDK or JRE) that is compatible with Java 1.8. Users of GAMA 1.6.1 should be aware that both Java 1.6 (provided by Apple) and Java 1.8 (supplied by Oracle) must be installed concurrently if you intend to keep a copy of GAMA 1.6.1. GAMA 1.6.1 won't function properly under Java 1.8 as a result of this SWT bug (https://bugs.eclipse.org/bugs/show_- bug.cgi id=374199); all the displays will be blank. Follow these directions to install the JDK 1.6 given by Apple: http://support.apple.com/kb/DL1572. As an alternative, you may want to go to https://developer.apple.com/downloads and, if you're not an Apple Developer, register for free before selecting the whole JDK from the list of downloads.


   * On Windows


Please be aware that Internet Explorer and Chrome will download a 32-bit version of the JRE by default. Running GAMA 32 bits on Windows is acceptable, but if you wish to boost the simulator's performance and run GAMA 64 bits, you might want to get the most recent JDK. Visit this page to obtain the required Java version:
https://www.oracle.com/technetwork/java/javase/downloads/jdk8-
Downloads-2133151.html then execute the downloaded file. After, you can check that a Java\jre8 folder has been installed at the location 
C:\Program Files\

Gama should now be completely operational going forward.


* LAUNCHING GAMA

The first time you run GAMA, you must launch the program (found in the GAMA_1.8_YOUR_OS_NAME folder after unzipping the downloaded files, and named Gama.app on MacOS X and Gama.exe on Windows). In order to run GAMA, you must double-click the application file (Gama.app on Mac OS X and Gama.exe on Windows) or open it from a terminal.


   * Note on launching GAMA on MAC OS X

The system on Mac OS X does a verification to see if the application was obtained from the Internet or from a reputable (by Apple) source. As a result, you must confirm that you want to open GAMA. A pop-up shows when GAMA is first started because GAMA does not originate from developers who have been approved by Apple therefore you must open the System Preferences window and select Security & Privacy before your computer may start GAMA. After that, in order to allow the system to start GAMA, click Open Anyway. You need to confirm your want to launch GAMA one more time.


   * Choosing a Workspace


After the splash screen, GAMA will prompt you to select a workspace where you can save your models along with the data and parameters that go with them. Any folder in your filesystem that you have read/write access to can serve as the workspace. In order for GAMA to observe your selection. Simply check the corresponding box the next time you run it (running Gama from the command line can be useful). If this box does not appear when GAMA is launched, you probably inherit from an older workspace that was used with an earlier version of GAMA and is still "remembered" by GAMA. If that happens, a notice will appear to let you know that the model library is outdated and give you the option of creating a new workspace.


Using the relevant button, you can browse your filesystem or input its address. The folder will be reused (with a warning if it is not already a workspace) if it already exists. It will be made if not. When you launch a new version of GAMA for the first time, it is always a good idea to create a new workspace. Later on, you'll be able to import your current models into it. If this isn't done, strange problems could occur during the various validation processes.


A pop-up will show when you attempt to select a workspace that was utilized with a previous version of GAMA. When a user attempts to create a new workspace in an empty folder, a pop-up window opens. To create the folder and designate it as the GAMA workspace, click OK.


   * WELCOME TO GAMA
GAMA will launch as soon as the workspace is formed, and its first window will be displayed to you. GAMA is based on Eclipse and makes use of the majority of its visual metaphors to arrange the modeler's work. The primary window is then divided into a number of sections that can be editors or views and are arranged in a perspective. Modeling, which focuses on the development of models, and Simulation, which focuses on their application and investigation, are the two key viewpoints that GAMA suggests. If you employ shared models, other viewpoints are accessible.


Modeling is the initial perspective that GAMA launches in. A Navigator view on the left side of the window, an Outline view (linked with the open editor), the Problems view, which displays errors and warnings found in the workspace-stored models, and an interactive console, which enables the modeler to experiment with expressions and see an immediate result, make up the workspace.


GAMA will display a Welcome page (actually a web page) in the absence of previously open models, from which you may access the website, the most recent documentation, tutorials, etc. This page can be securely closed (and later opened through the "Views" option) or left open (for example, if you want to show the documentation when changing models). From this point on, you can edit new models, look through the model library, or import already-existing models.


   2. IMPORTING AN EXISTING MODEL
Making a model file (or an entire project) available for editing and testing in the workspace is referred to as "import." GAMA needs that models be workable in the present workspace in order to be able to validate them and eventually experiment with them, with the exception of headless experiments. A model may need to be imported by the user in a variety of circumstances, including when it was emailed to them, was an attachment to a bug report, was shared online or in a Git repository, or was part of a prior workspace before the user switched workspaces.


Since model files must reside in a project in order for GAMA to manage them, it is typically preferable to import an entire project as opposed to a single file (unless, of course, the corresponding models are straightforward enough not to require any additional resources, in which case the model file can be imported into an existing project without harm). When a model file is imported alone, GAMA will attempt to identify these instances and, if a corresponding project can be discovered (for example, in the top directories of this file), import the project rather than the file. Finally, GAMA will import orphan model files into a general project called "Unclassified Models" (which will be created if it doesn't already exist).


   * The “Import” Menu Command


The built-in "Import..." menu command, found in the contextual menu on the User models (the modeler can only import projects in this category), is the easiest, safest, and most secure way to import a project into the workspace. The modeler has the option of selecting "GAMA Project...," "External files from disk...," "External files from archive...," or "Other" when using the "Import..." command.
   * IMPORTING A GAMA PROJECT
When the user selects the "GAMA project..." to import the study, a dialog box with the following instructions appears:


   * Enter the location (or go to the location) where the GAMA project(s) you want to import are located. This could be a folder for a single project or one for a collection of projects. There are two options available, using "Select root directory" allows the user to choose a folder containing the project, or "Select archive file" allows them to choose an archive file (in this case, the Lim_Experiment zip file) containing the project.
   * Choose the projects to import successfully from the list of available projects (which is the Lim_Study as determined by GAMA). Projects can only be imported if they don't already exist in the workspace. Note that the project consist of 5 .gaml models namely: Scenario01.gaml, Scenario02.1.gaml, Scenario02.2.gaml, Scenario03.gaml, and Scenario04.gaml as well as the building and road shape files for the implementation of the virtual environment.
   * Indicate whether these projects should be connected from the workspace or copied there (the latter is the default). When importing content from an archive, the workspace will receive an automated copy of the content.


   3. RUNNING EXPERIMENTS


The only way to run simulations on a model in GAMA is to run an experiment. There are numerous ways to conduct experiments. The first and most popular method involves launching an experiment from the modeling viewpoint and running simulations using the user interface suggested by the simulation perspective. The second method, described on this page, enables automated experiment launch when GAMA is opened while continuing to use the same user interface. The final method, referred to as doing headless experiments, completely relies on the command line to control GAMA without using the user interface. With the exception of the last method, which omits all computations required to represent simulations on displays or in the UI, all three methods are computationally identical. They only differ in terms of how they are used, with the first one being heavily used when creating models or demonstrating a number of models, the second one being intended for use when demonstrating or experimenting with a single model, and the third one being helpful when running numerous simulations, especially over networks or computer grids.


   * LAUNCHING EXPERIMENTS FROM THE EDITOR


When a model with experiment definitions is validated, the experiments will show up as separate buttons in the header ribbon above the text in the order in which they are defined in the file. Any of these buttons can be clicked to start the associated experiment. To execute your chosen GAMA scenario, open its editor and click on the “main_experiment” to launch the experiment.


   * UNDERSTANDING THE WORKSPACES UPON RUNNING THE EXPERIMENT
Upon launching the experiment, 4 workspaces will appear namely the console, monitor, virtual environment, and chart display. The following are the definition of each workspaces:


   * Console: This is where the number of current susceptible, exposed, infected, recovered, and dead agents are automatically printed per day.
   * Monitor: This is where you can track the number and rate of infection per iteration, namely the current day in the simulation as well as the current population, number of susceptible, exposed, infected, recovered, dead agents per iteration, the current hour and minute, and the current infection rate.
   * Virtual Environment: This is where the user could visualize what was happening inside the facility real-time/ per iteration. It is a 3D representation of the virtual environment with the agents in it categorized as susceptible, exposed, infected, recovered, and dead.
   * Chart Display: This is a time-series graph to keep track of the numbers of each agent throughout the experiment which will be used to analyze the behavior of the COVID 19 transmission risk inside the facility.


   * EXPERIMENT MENU
The current experiment can be managed using the "Experiment" menu. Some of its commands are shared with the default toolbar. 


   * Run/Pause Experiment: Permits the experiment to be conducted or paused depending on its condition.
   * Step Experiment: Performs the test for one cycle/iteration and then stops it.
   * Reloads Experiment: The current experiment is stopped, its contents are deleted, and it is then loaded again, taking into account any parameter values that the user may have modified.
   * Close Experiment: Clears the memory from the experiment, compels it to halt what it is doing, then switches to the modeling viewpoint. If the experiment is in a condition where it is reading files or producing data, for instance, using this command could result in unwanted results.


The Codes, Documentation, and this study is developed by Lyka Raquel Lim in 2023 when she was an undergraduate student at the University of the Philippines - Baguio taking up Bachelor of Science in Computer Science.