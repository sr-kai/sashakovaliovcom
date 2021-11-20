<?php
// Matomo extension, https://github.com/datenstrom/yellow-extensions/tree/master/features/matomo
// Copyright (c) 2013-2019 Datenstrom, https://datenstrom.se
// This file may be used and distributed under the terms of the public license.

class YellowMatomo {
    const VERSION = "0.8.2";
    const TYPE = "feature";
    public $yellow;            //access to API
    
    // Handle initialisation
    public function onLoad($yellow) {
        $this->yellow = $yellow;
        $this->yellow->system->setDefault("matomoUrl", "");
        $this->yellow->system->setDefault("matomoSiteId", "yellow");
    }
    
    // Handle page extra data
    public function onParsePageExtra($page, $name) {
        $output = NULL;
        if ($name=="footer") {
            $url = $this->yellow->system->get("matomoUrl");
            $siteId = $this->yellow->system->get("matomoSiteId");
            if (empty($url)) $url = $this->yellow->toolbox->getServerUrl();
            $output = "<script type=\"text/javascript\">\n";
            $output .= "(function(f, a, t, h, o, m){a[h]=a[h]||function(){(a[h].q=a[h].q||[]).push(arguments)};\n";
            $output .= "o=f.createElement('script'),m=f.getElementsByTagName('script')[0];o.async=1; o.src=t; o.id='fathom-script';\n";
            $output .= "m.parentNode.insertBefore(o,m)})(document, window, '//cdn.usefathom.com/tracker.js', 'fathom');\n";
            $output .= "fathom('set', 'siteId', 'HXPOPXOC');\n";
            $output .= "fathom('trackPageview')\n";
            $output .= "</script>\n";
        }
        return $output;
    }
}