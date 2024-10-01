---
title: "The Q Continuum, Part 5: open source mobile GIS in archaeology – future prospects"
---

## 

## QField or Input?

In this tutorial we've used QField as our mobile GIS. 
There other ways to combine open source ([GeoODK](http://geoodk.com/index.html),[^1] [FAIMS Mobile](https://www.fedarch.org/faims-mobile/)) or proprietery ([FileMaker Go](https://www.claris.com/filemaker/go/), [ArcGIS Collector](https://www.esri.com/en-us/arcgis/products/arcgis-collector)) mobile data collection applications with QGIS.
We went with QField primarily because it provides a direct port of QGIS to mobile operating systems, allowing us to use its powerful cartographic and form functionality in the field.

[Input](https://inputapp.io/) is another QGIS-based mobile data collection app that was recently released as an alternative to QField.
It began as a fork of QField and as of writing the two apps still very similar.
But two features make Input a promising alternative to QField for archaeologists:
* Input is available for iOS as well as Android. iOS support for QField [has been planned for a while](https://github.com/opengisch/QField/issues/122) but seems to be held up by licensing problems.
* Input's sync plugin, [Mergin](https://public.cloudmergin.com/), is cloud-based, removing the need to manually transfer project files between devices and potentially providing an easier foundation for multi-user syncing. However, it requires a subscription for projects larger than 100 MB.

Input also currently has a more polished interface that scales better to smaller screens (i.e. phones rather than tablets).

Both apps are in active development so it remains to be seen whether this comparison will hold in the future.
There does not seem to be anything stopping you from using Mergin's cloud services with QField, for example.

## Standards

* Any point in settling on one data collection standard?
* The end result is most important, but starting with standards in mind can't hurt.
* That said, in field projects flexibility is king: "grand unifying" data recording systems seem doomed to failure.
* But at the very least, sharing e.g. QGIS project files with forms will reduce duplicated effort.
  * Put this tutorial's files on GitHub for that reason.

---

[^1]: See Isaac Ullah's [mobile data-collection workflow for archaeologists](https://isaacullah.github.io/A-mobile-field-data-collection-workflow/), for example.
