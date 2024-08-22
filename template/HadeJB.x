BOOL allowAccess(NSString *filename) {
   NSArray *NotAllowedPathPrefixes =
   @[
    @"/bin",
   @"/usr/bin",
   @"/usr/sbin",
   @"/etc/apt",
   @"/usr/libexec/sftp-server",
   @"/private/var/lib",
   @"/private/var/stash",
   @"/private/var/mobile/Library/SBSettings",
   @"/private/jailbreak.txt",
   @"/private/var/tmp/cydia.log",
   @"/Applications/",
   @"/Library/MobileSubstrate",
   @"/Library/MobileSubstrate/MobileSubstrat",
   @"/Applications/Cydia.app",
    @"/bin/sh",
    @"/bin/bash",
    @"/Library/MobileSubstrate/MobileSubstrate.dylib",
    @"/usr/sbin/sshd",
    @"/etc/apt",
	@"/usr/bin/ssh",
	@"/Applications/blackra1n.app",
	@"/Applications/FakeCarrier.app",
	@"/Applications/Icy.app",
	@"/Applications/IntelliScreen.app",
	@"/Applications/MxTube.app",
	@"/Applications/RockApp.app",
	@"/Applications/SBSettings.app",
	@"/Applications/WinterBoard.app",
	@"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
	@"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
	@"/private/var/lib/apt",
	@"/private/var/lib/cydia",
	@"/private/var/mobile/Library/SBSettings/Themes",
	@"/System/Library/LaunchDaemons",
	@"/usr/bin/sshd",
	@"/usr/libexec/sftp-server",
   ];

   if (filename.length == 0) {
     return YES;
   }
   for (NSString *prefix in NotAllowedPathPrefixes) {
     if ([filename hasPrefix:prefix]) {
       return NO;
     }
   }
   return YES;
}

%hook NSFileManager
- (BOOL)fileExistsAtPath:(NSString *)path {
  if(!allowAccess(path)){
    return NO;
  }
  return %orig;
}
%end