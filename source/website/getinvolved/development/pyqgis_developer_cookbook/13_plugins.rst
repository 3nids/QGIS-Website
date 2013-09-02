.. index:: plugins; developing, Python; developing plugins

.. _developing_plugins:

*************************
Developing Python Plugins
*************************

It is possible to create plugins in Python programming language. In comparison
with classical plugins written in C++ these should be easier to write,
understand, maintain and distribute due the dynamic nature of the Python
language.

Python plugins are listed together with C++ plugins in QGIS plugin manager.
They're being searched for in these paths:

    * UNIX/Mac: :file:`~/.qgis/python/plugins` and :file:`(qgis_prefix)/share/qgis/python/plugins`
    * Windows: :file:`~/.qgis/python/plugins` and :file:`(qgis_prefix)/python/plugins`

Home directory (denoted by above :file:`~`) on Windows is usually something
like :file:`C:\\Documents and Settings\\(user)`. Subdirectories of these
paths are considered as Python packages that can be imported to QGIS as plugins.

Steps:

1. *Idea*: Have an idea about what you want to do with your new QGIS plugin.
   Why do you do it?
   What problem do you want to solve?
   Is there already another plugin for that problem?

2. *Create files*: Create the files described next.
   A starting point (:file:`__init.py__`).
   Fill in the :ref:`plugin_metadata` (:file:`metadata.txt`)
   A main python plugin body (:file:`plugin.py`).
   A form in QT-Designer (:file:`form.ui`), with its :file:`resources.qrc`.

3. *Write code*: Write the code inside the :file:`plugin.py`

4. *Test*: Close and re-open QGIS and import your plugin again. Check if
   everything is OK.

5. *Publish*: Publish your plugin in QGIS repository or make your own
   repository as an "arsenal" of personal "GIS weapons"

.. index:: plugins; writing

Writing a plugin
================

Since the introduction of python plugins in QGIS, a number of plugins have
appeared - on `Plugin Repositories wiki page <http://www.qgis.org/wiki/Python_Plugin_Repositories>`_
you can find some of them, you can use their source to learn more about
programming with PyQGIS or find out whether you are not duplicating development
effort. QGIS team also maintains an :ref:`official_pyqgis_repository`.
Ready to create a plugin but no idea what to do? `Python Plugin Ideas wiki page <http://www.qgis.org/wiki/Python_Plugin_Ideas>`_ lists wishes from the community!


Creating necessary files
------------------------

Here's the directory structure of our example plugin::

  PYTHON_PLUGINS_PATH/
    testplug/
      __init__.py
      plugin.py
      metadata.txt
      resources.qrc
      resources.py
      form.ui
      form.py

What is the meaning of the files:

* :file:`__init__.py` = The starting point of the plugin. It is normally empty.
* :file:`plugin.py` = The main working code of the plugin. Contains all the information
  about the actions of the plugin and the main code.
* :file:`resources.qrc` = The .xml document created by QT-Designer. Contains relative
  paths to resources of the forms.
* :file:`resources.py` = The translation of the .qrc file described above to Python.
* :file:`form.ui` = The GUI created by QT-Designer.
* :file:`form.py` = The translation of the form.ui described above to Python.
* :file:`metadata.txt` = Required for QGIS >= 1.8.0. Containts general info, version,
  name and some other metadata used by plugins website and plugin infrastructure.
  Metadata in :file:`metadata.txt` is preferred to the methods in :file:`__init__.py`.
  If the text file is present, it is used to fetch the values. From QGIS 2.0
  the metadata from :file:`__init__.py` will not be accepted and the :file:`metadata.txt`
  file will be required.

`Here <http://pyqgis.org/builder/plugin_builder.py>`_ and `there <http://www.dimitrisk.gr/qgis/creator/>`_
are two automated ways of creating the basic files (skeleton) of a typical
QGIS Python plugin. Also there is a QGIS plugin called `Plugin Builder`
that creates plugin template from QGIS and don't require internet connection.
Useful to help you start with a typical plugin.

.. warning::
    If you plan to upload the plugin to the :ref:`official_pyqgis_repository` you must
    check that your plugin follows some additional rules, required for plugin  :ref:`official_pyqgis_repository_validation`


.. index:: plugins; writing code

Writing code
============

.. index:: plugins; metadata.txt


.. _plugin_metadata:

Plugin metadata
---------------

First, plugin manager needs to retrieve some basic information about the
plugin such as its name, description etc. File :file:`metadata.txt` is the
right place where to put this information.


.. important::
    All metadata must be in UTF-8 encoding.

.. _plugin_metadata_table:

=====================  ========  =======================================
Metadata name          Required  Notes
=====================  ========  =======================================
name                   True      a short string  containing the name of the plugin
qgisMinimumVersion     True      dotted notation of minimum QGIS version
qgisMaximumVersion     False     dotted notation of maximum QGIS version
description            True      longer text which describes the plugin, no HTML allowed
version                True      short string with the version dotted notation
author                 True      author name
email                  True      email of the author, will *not* be shown on the web site
changelog              False     string, can be multiline, no HTML allowed
experimental           False     boolean flag, `True` or `False`
deprecated             False     boolean flag, `True` or `False`, applies to the whole plugin and not just to the uploaded version
tags                   False     comma separated list, spaces are allowe inside individual tags
homepage               False     a valid URL pointing to the homepage of your plugin
repository             False     a valid URL for the source code repository
tracker                False     a valid URL for tickets and bug reports
icon                   False     a file name or a relative path (relative to the base folder of the plugin's compressed package)
category               False     one of `Raster`, `Vector`, `Database` and `Web`
=====================  ========  =======================================


In QGIS 1.9.90 plugins can be placed not only into `Plugins` menu but also
into `Raster`, `Vector`, `Database` and `Web` menus. Therefore a new "category"
metadata entry has been introduced. This metadata entry is used as tip for
users and tells them where (in which menu) the plugin can be found. Allowed
values for "category" are: Vector, Raster, Database, Web and Layers. For
example, if your plugin will be available from `Raster` menu, add this to
:file:`metadata.txt`:.


.. note::
 If `qgisMaximumVersion` is empty, it will be automatically set to the major version plus `.99` when uploaded to the :ref:`official_pyqgis_repository`.


An exampe for this metadata.txt::

  ; the next section is mandatory

  [general]
  name=HelloWorld
  email=me@example.com
  author=Just Me
  qgisMinimumVersion=1.8
  description=This is a plugin for greeting the
      (going multiline) world
  version=version 1.2
  ; end of mandatory metadata

  ; start of optional metadata
  category=Raster
  changelog=this is a very
      very
      very
      very
      very
      very long multiline changelog

  ; tags are in comma separated value format, spaces are allowed
  tags=wkt,raster,hello world

  ; these metadata can be empty
  homepage=http://www.itopen.it
  tracker=http://bugs.itopen.it
  repository=http://www.itopen.it/repo
  icon=icon.png

  ; experimental flag
  experimental=True

  ; deprecated flag (applies to the whole plugin and not only to the uploaded version)
  deprecated=False

  ; if empty, it will be automatically set to major version + .99
  qgisMaximumVersion=1.9


.. index:: plugins; metadata.txt, metadata, metadata.txt



plugin.py
---------

One thing worth mentioning is ``classFactory()`` function which is called
when the plugin gets loaded to QGIS. It receives reference to instance of
:class:`QgisInterface` and must return instance of your plugin - in our
case it's called ``TestPlugin``. This is how should this class look like
(e.g. :file:`testplugin.py`)::

  from PyQt4.QtCore import *
  from PyQt4.QtGui import *
  from qgis.core import *

  # initialize Qt resources from file resouces.py
  import resources

  class TestPlugin:

    def __init__(self, iface):
      # save reference to the QGIS interface
      self.iface = iface

    def initGui(self):
      # create action that will start plugin configuration
      self.action = QAction(QIcon(":/plugins/testplug/icon.png"), "Test plugin", self.iface.mainWindow())
      self.action.setWhatsThis("Configuration for test plugin")
      self.action.setStatusTip("This is status tip")
      QObject.connect(self.action, SIGNAL("triggered()"), self.run)

      # add toolbar button and menu item
      self.iface.addToolBarIcon(self.action)
      self.iface.addPluginToMenu("&Test plugins", self.action)

      # connect to signal renderComplete which is emitted when canvas rendering is done
      QObject.connect(self.iface.mapCanvas(), SIGNAL("renderComplete(QPainter *)"), self.renderTest)

    def unload(self):
      # remove the plugin menu item and icon
      self.iface.removePluginMenu("&Test plugins",self.action)
      self.iface.removeToolBarIcon(self.action)

      # disconnect form signal of the canvas
      QObject.disconnect(self.iface.mapCanvas(), SIGNAL("renderComplete(QPainter *)"), self.renderTest)

    def run(self):
      # create and show a configuration dialog or something similar
      print "TestPlugin: run called!"

    def renderTest(self, painter):
      # use painter for drawing to map canvas
      print "TestPlugin: renderTest called!"


If you use QGIS 1.9.90 or higher and want to place your plugin into one of the
new menus (`Raster`, `Vector`, `Database` or `Web`), you should modify the code
of the ``initGui()`` and ``unload()`` functions. Since these new menus are
available only in QGIS 1.9.90, our first step is to check if the running QGIS
version has all necessary functions. If the new menus are available, we will
place our plugin under this menu, otherwise we will use the old `Plugins` menu.
Here is an example for `Raster` menu::

    def initGui(self):
      # create action that will start plugin configuration
      self.action = QAction(QIcon(":/plugins/testplug/icon.png"), "Test plugin", self.iface.mainWindow())
      self.action.setWhatsThis("Configuration for test plugin")
      self.action.setStatusTip("This is status tip")
      QObject.connect(self.action, SIGNAL("triggered()"), self.run)

      # check if Raster menu available
      if hasattr(self.iface, "addPluginToRasterMenu"):
        # Raster menu and toolbar available
        self.iface.addRasterToolBarIcon(self.action)
        self.iface.addPluginToRasterMenu("&Test plugins", self.action)
      else:
        # there is no Raster menu, place plugin under Plugins menu as usual
        self.iface.addToolBarIcon(self.action)
        self.iface.addPluginToMenu("&Test plugins", self.action)

      # connect to signal renderComplete which is emitted when canvas rendering is done
      QObject.connect(self.iface.mapCanvas(), SIGNAL("renderComplete(QPainter *)"), self.renderTest)

    def unload(self):
      # check if Raster menu available and remove our buttons from appropriate
      # menu and toolbar
      if hasattr(self.iface, "addPluginToRasterMenu"):
        self.iface.removePluginRasterMenu("&Test plugins",self.action)
        self.iface.removeRasterToolBarIcon(self.action)
      else:
        self.iface.removePluginMenu("&Test plugins",self.action)
        self.iface.removeToolBarIcon(self.action)

      # disconnect form signal of the canvas
      QObject.disconnect(self.iface.mapCanvas(), SIGNAL("renderComplete(QPainter *)"), self.renderTest)


A full list of methods that can be used to place plugin under these menus/toolbars is
available in the `API docs <http://qgis.org/api/classQgisInterface.html>`_.

The only plugin functions that must exist are ``initGui()`` and ``unload()``.
These functions are called when the plugin is loaded and unloaded.

.. index:: plugins; resource file, resources.qrc

Resource File
-------------

You can see that in ``initGui()`` we've used an icon from the resource file
(called :file:`resources.qrc` in our case)::

  <RCC>
    <qresource prefix="/plugins/testplug" >
       <file>icon.png</file>
    </qresource>
  </RCC>

It is good to use a prefix that will not collide with other plugins or any
parts of QGIS, otherwise you might get resources you did not want. Now you
just need to generate a Python file that will contain the resources. It's
done with :command:`pyrcc4` command::

  pyrcc4 -o resources.py resources.qrc

And that's all... nothing complicated :)
If you've done everything correctly you should be able to find and load
your plugin in plugin manager and see a message in console when toolbar
icon or appopriate menu item is selected.

When working on a real plugin it's wise to write the plugin in another
(working) directory and create a makefile which will generate UI + resource
files and install the plugin to your QGIS installation.

.. index:: plugins; documentation, plugins; implementing help

Documentation
=============

*This documentation method requires Qgis version 1.5.*

The documentation for the plugin can be written as HTML help files. The
:mod:`qgis.utils` module provides a function, :func:`showPluginHelp` which
will open the help file users browser, in the same way as other QGIS help.

The :func:`showPluginHelp`` function looks for help files in the same
directory as the calling module. It will look for, in turn, :file:`index-ll_cc.html`,
:file:`index-ll.html`, :file:`index-en.html`, :file:`index-en_us.html` and
:file:`index.html`, displaying whichever it finds first. Here ``ll_cc``
is the QGIS locale. This allows multiple translations of the documentation
to be included with the plugin.

The :func:`showPluginHelp` function can also take parameters packageName,
which identifies a specific plugin for which the help will be displayed,
filename, which can replace "index" in the names of files being searched,
and section, which is the name of an html anchor tag in the document
on which the browser will be positioned.

.. index:: plugins; code snippets

Code Snippets
=============

This section features code snippets to facilitate plugin development.

.. index:: plugins; call method with shortcut

How to call a method by a key shortcut
--------------------------------------

In the plug-in add to the ``initGui()``::

  self.keyAction = QAction("Test Plugin", self.iface.mainWindow())
  self.iface.registerMainWindowAction(self.keyAction, "F7") # action1 is triggered by the F7 key
  self.iface.addPluginToMenu("&Test plugins", self.keyAction)
  QObject.connect(self.keyAction, SIGNAL("triggered()"),self.keyActionF7)

To ``unload()`` add::

  self.iface.unregisterMainWindowAction(self.keyAction)

The method that is called when F7 is pressed::

  def keyActionF7(self):
    QMessageBox.information(self.iface.mainWindow(),"Ok", "You pressed F7")

.. index:: plugins; toggle layers

How to toggle Layers (work around)
----------------------------------

*Note:* from QGIS 1.5 there is :class:`QgsLegendInterface` class that allows
some manipulation with list of layers within legend.

As there is currently no method to directly access the layers in the legend,
here is a workaround how to toggle the layers using layer transparency::

  def toggleLayer(self, lyrNr):
    lyr = self.iface.mapCanvas().layer(lyrNr)
    if lyr:
      cTran = lyr.getTransparency()
      lyr.setTransparency(0 if cTran > 100 else 255)
      self.iface.mapCanvas().refresh()

The method requires the layer number (0 being the top most) and can be called by::

  self.toggleLayer(3)

.. index:: plugins; access attributes of selected features

How to access attribute table of selected features
--------------------------------------------------

::

  def changeValue(self, value):
    layer = self.iface.activeLayer()
    if(layer):
      nF = layer.selectedFeatureCount()
      if (nF > 0):
      layer.startEditing()
      ob = layer.selectedFeaturesIds()
      b = QVariant(value)
      if (nF > 1):
        for i in ob:
        layer.changeAttributeValue(int(i),1,b) # 1 being the second column
      else:
        layer.changeAttributeValue(int(ob[0]),1,b) # 1 being the second column
      layer.commitChanges()
      else:
        QMessageBox.critical(self.iface.mainWindow(),"Error", "Please select at least one feature from current layer")
    else:
      QMessageBox.critical(self.iface.mainWindow(),"Error","Please select a layer")


The method requires the one parameter (the new value for the attribute
field of the selected feature(s)) and can be called by::

  self.changeValue(50)

.. index:: plugins; debugging with PDB, debugging plugins

How to debug a plugin using PDB
-------------------------------

First add this code in the spot where you would like to debug::

 # Use pdb for debugging
 import pdb
 # These lines allow you to set a breakpoint in the app
 pyqtRemoveInputHook()
 pdb.set_trace()

Then run QGIS from the command line.

On Linux do:

:command:`$ ./Qgis`

On Mac OS X do:

:command:`$ /Applications/Qgis.app/Contents/MacOS/Qgis`

And when the application hits your breakpoint you can type in the console!

.. index:: plugins; testing

.. note::
    Add testing informations

.. index:: plugins; releasing

Releasing the plugin
====================

Once your plugin is ready and you think the plugin could be helpful for
some people, do not hesitate to upload it to :ref:`official_pyqgis_repository`.
On that page you can find also packaging guidelines how to prepare the
plugin to work well with the plugin installer. Or in case you would like
to set up your own plugin repository, create a simple XML file that will
list the plugins and their metadata, for examples see other `plugin repositories <http://www.qgis.org/wiki/Python_Plugin_Repositories>`_.

.. index:: plugins; Windows IDE configuration


.. _official_pyqgis_repository:

Official python plugin repository
---------------------------------

You can find the *official* python plugin repository at `<http://plugins.qgis.org/>`_.

In order to use the official repository you must obtain an OSGEO ID from the `OSGEO web portal <http://www.osgeo.org/osgeo_userid/>`_.

Once you have uploaded your plugin it will be approved by a staff member and you will be notified.

.. note::
   Insert a link to the governance document

.. index:: plugins; official python plugin repository


Permissions
...........

These rules have been implemented in the official plugin repository:
    * every registered user can add a new plugin
    * *staff* users can approve or disapprove all plugin versions
    * users which have the special permission `plugins.can_approve` get the versions they upload automatically approved
    * users which have the special permission `plugins.can_approve` can approve versions uploaded by others as long as they are in the list of the plugin *owners*
    * a particular plugin can be deleted and edited only by *staff* users and plugin *owners*
    * if a user without `plugins.can_approve` permission uploads a new version, the plugin version is automatically unapproved.


Trust management
................

Staff members can grant *trust* to selected plugin creators setting `plugins.can_approve` permission through the front-end application.

The plugin details view offers direct links to grant trust to the plugin creator or the plugin *owners*.

.. _official_pyqgis_repository_validation:

Validation
..........

Plugin's metadata are automatically imported and validated from the compressed package when the plugin is uploaded.

Here are some validation rules that you should aware of when you want to upload a plugin
on the official repository:

#. the name of the main folder containing your plugin must contain only contains ASCII characters (A-Z and a-z), digits and the characters underscore (_) and minus (-), also it cannot start with a digit
#. :file:`metadata.txt` is required
#. all required metadata listed in :ref:`metadata table<plugin_metadata_table>` must be present
#. the `version` metadata field must be unique



Remark: Configuring Your IDE on Windows
=======================================

On Linux there is no additional configuration needed to develop plug-ins.
But on Windows you need to make sure you that you have the same environment
settings and use the same libraries and interpreter as QGIS. The fastest
way to do this, is to modify the startup batch file of QGIS.

If you used the OSGeo4W Installer, you can find this under the bin folder
of your OSGoeW install. Look for something like :file:`C:\\OSGeo4W\\bin\\qgis-unstable.bat`.

I will illustrate how to set up the `Pyscripter IDE <http://code.google.com/p/pyscripter>`_.
Other IDEs might require a slightly different approach:

* Make a copy of qgis-unstable.bat and rename it pyscripter.bat.
* Open it in an editor. And remove the last line, the one that starts qgis.
* Add a line that points to the your pyscripter executable and add the
  commandline argument that sets the version of python to be used, in
  version 1.3 of qgis this is python 2.5.
* Also add the argument that points to the folder where pyscripter can
  find the python dll used by qgis, you can find this under the bin folder
  of your OSGeoW install::

    @echo off
    SET OSGEO4W_ROOT=C:\OSGeo4W
    call "%OSGEO4W_ROOT%"\bin\o4w_env.bat
    call "%OSGEO4W_ROOT%"\bin\gdal16.bat
    @echo off
    path %PATH%;%GISBASE%\bin
    Start C:\pyscripter\pyscripter.exe --python25 --pythondllpath=C:\OSGeo4W\bin

Now when you double click this batch file and it will start pyscripter.
