# mdns_plugin_example

This example application demonstrates how to use the mdns_plugin plugin. It
generates a list of services which are presented as a ListView:

<img src="https://raw.githubusercontent.com/djthorpe/flutter/master/mdns_plugin/example/etc/screenshot.png" style="width:50%" >

See the code in the `example/lib` folder:

  * The `bloc` folder contains the business logic of the application;
  * The `models` folder contains the model for the list of services;
  * The `pages` folder contains the StatelessWidget which renders the page;
  * The `widgets` folder contains the widget to render a service as a list item;

The list is rebuilt based on delegate messages from the `MDNSPlugin` object, which
you can see in the `bloc/app.dart` business logic.

