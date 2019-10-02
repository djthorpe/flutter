package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import ca.michaux.peter.zeroconf.ZeroconfPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    ZeroconfPlugin.registerWith(registry.registrarFor("ca.michaux.peter.zeroconf.ZeroconfPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
