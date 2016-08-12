#!/usr/bin/php5
<?php
/*
# Adebar
# (Android DEvice Backup And Restore)
# Creating scripts to backup and restore your apps, settings, and more
# © 2014 by Andreas Itzchak Rehberg
# Licensed using GPLv2 (see the file LICENSE which should have shipped with this)
*/

# Parse arguments
if ( !isset($argv[1]) ) {
  echo "Syntax: ".$argv[0]." <output_dir> [doc_dir]\n";
  exit;
}
$outdir  = $argv['1'];
if (empty($argv['2'])) $docdir = $outdir;
else $docdir  = $argv['2'];
$pkg_xml = $docdir.'/packages.xml';

if ( !file_exists($pkg_xml) ) die("No packages.xml found in $docdir.\n");

require "xml2array.php";

# Configuration
$markdownUserApps = $docdir.'/userApps.md';
$markdownDisabled = $docdir.'/deadReceivers.md';
$adbDisabled = $outdir.'/deadReceivers.sh';

$contents = file_get_contents($pkg_xml);
$result = xml2array($contents,1,'attribute');


/** Get disabled components
 * @param array result as returned by xml2array
 * @param string mdfile MarkDown output file
 * @param string adbfile ADB command output file (script to run to disable the components)
 */
function disabledComponents($result,$mdfile,$adbfile) {
  $md = '';
  $adb = "#!/usr/bin/env bash\n# Disable Components\n\n";
  foreach($result['packages']['package'] as $key => $package) {
    if ( !isset($package['attr']['name']) ) continue;
    $name = $package['attr']['name'];
    if ( !isset($package['disabled-components']) ) continue;

    $md .= "## $name\n";
    foreach($package['disabled-components'] as $item) {
      if (isset($item['attr']['name']) ) {
        $md .= "* ".$item['attr']['name']."\n";
        $adb .= "adb shell \"pm disable $name/".$item['attr']['name']."\"\n";
      } else {
        foreach($item as $it) {
          $adb .= "adb shell \"pm disable $name/".$it['attr']['name']."\"\n";
          $md .= "* ".$it['attr']['name']."\n";
        }
      }
    }
    $md .= "\n";
    $adb .= "\n";
    file_put_contents($mdfile,$md);
    file_put_contents($adbfile,$adb);
  }
}

/** Get user-installed apps with their sources
 * @param array result as returned by xml2array
 * @param string mdfile MarkDown output file
 */
function userApps($result,$mdfile) {
  static $known_sources = array('org.fdroid.fdroid','cm.aptoide.pt','com.android.vending','com.google.android.feedback','other');
  static $source_names  = array(
    'org.fdroid.fdroid'=>'F-Droid',
    'cm.aptoide.pt'=>'Aptoide',
    'com.android.vending'=>'Google Play',
    'com.google.android.feedback'=>'Google Play (Feedback)',
    'other'=>'Unknown Source'
  );
  foreach($known_sources as $src) ${$src} = array();
  $md = '';
  foreach($result['packages']['package'] as $key => $package) {
    $preg='!^/system/!';
    if ( !isset($package['attr']['installer']) ) {
      if ( preg_match($preg,$package['attr']['codePath']) ) continue;
      $package['attr']['installer'] = 'other';
    }
    if ( !in_array($package['attr']['installer'],$known_sources) || preg_match($preg,$package['attr']['codePath']) ) continue;
    if ( preg_match('!^/data/!',$package['attr']['codePath']) ) $target = 'intern';
    else $target = 'App2SD';
    ${$package['attr']['installer']}[] = array(
      'name'   => $package['attr']['name'],
      'target' => $target
    );
  }
  foreach($known_sources as $src) {
    if ( empty(${$src}) ) continue;
    $md .= '## '.$source_names[$src]."\n";
    foreach (${$src} as $s) {
      $md .= '* '.$s['name'].' ('.$s['target'].")\n";
    }
    $md .= "\n";
  }
  file_put_contents($mdfile,$md);
}

disabledComponents($result,$markdownDisabled,$adbDisabled);
userApps($result,$markdownUserApps);

//print_r($result['packages']['package'])

// who installed the app: $package['attr']['installer'] (usually "com.android.vending")
// - org.fdroid.fdroid
// - cm.aptoide.pt
// - com.android.vending
// - com.google.android.feedback
// - [self:preinstalled,side-loaded]
// more package info in 'attr':
// - codePath (apk-file)
// - nativeLibraryPath (/data/data/com.foobar/lib)
// - enabled (int: conditional/regional apps?) 3=frozen?

?>
