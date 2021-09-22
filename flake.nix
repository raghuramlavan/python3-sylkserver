{
  description = "Sylk Server Python 3.8";
  
  inputs.nixpkgs.url = "nixpkgs/nixos-20.09";
  
  inputs.python-gnutls-src = {
    url = github:/AGProjects/python3-gnutls;
    flake = false;
  };
  inputs.python-otr-src = {
    url = github:AGProjects/python3-otr;
    flake = false;
  };
  inputs.python-eventlib-src = {
    url = github:AGProjects/python3-eventlib;
    flake = false;
  };

  inputs.python3-xcaplib-src = {
    url = github:AGProjects/python3-xcaplib;
    flake = false;
  };

  inputs.python3-msrplib-src = {
    url = github:AGProjects/python3-msrplib;
    flake = false;
  };
 
  inputs.python-sipsimple-src = {
    url = github:raghuramlavan/python3-sipsimple;
    flake = false;
  };
  
  inputs.python-application-src = { 
    url = github:AGProjects/python3-application; 
    flake = false; 
  };
  inputs.python-sylkserver-src = {
    url = github:AGProjects/sylkserver;
    flake = false;
  };
  
  inputs.python-wokkel ={
    url="https://files.pythonhosted.org/packages/6a/77/0ed9531b5374bdd0537c3cba62b9fc4f43f02ffd2bdc7da0572b965fc61a/wokkel-18.0.0.tar.gz";
    flake =false;
  };

  outputs =
    { self
    , nixpkgs
    , python-gnutls-src
    , python-application-src
    , python-otr-src
    , python-eventlib-src
    , python-sipsimple-src
    , python-sylkserver-src
    , python3-xcaplib-src
    , python3-msrplib-src
    , python-wokkel
    }:
    let


      supportedSystems = [ "x86_64-linux" ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);


      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });

    in

    {

      # A Nixpkgs overlay.
      overlay = final: prev: {

        python-gnutls = with final; python3.pkgs.buildPythonPackage rec {
          pname = "python-gnutls-src";
          version = "3.1.3";

          src = python-gnutls-src;
          buildInputs = [
            pkgs.gnutls.bin
          ];
         patchPhase = ''
           substituteInPlace gnutls/library/__init__.py --replace "/usr/local/lib" "${pkgs.gnutls.out}/lib"
         '';
          propagatedBuildInputs = [
            python3Packages.twisted
            python3Packages.pyopenssl
            python3Packages.service-identity
            pkgs.gnutls
          ];
          doCheck=true;
          checkInputs = [
           pkgs.gnutls
          ];

          meta = with lib; {
            description = "Python wrapper for the GnuTLS Library";
            homepage = https://github.com/AGProjects/python-gnutls;
            license = licenses.lgpl2Plus;
          };
        };


        python-wokkel = with final; python3.pkgs.buildPythonPackage rec {
          pname = "wokkel";
          version = "18.0.0";

          src = python-wokkel;

          doCheck = true;

          meta = with lib; {
            description = "Python Wokkel -  testing ground for enhancements to the Jabber/XMPP protocol implementation as found in Twisted Words";
            homepage = https://wokkel.ik.nu/;
            license = licenses.lgpl2Plus;
          };
        };

 
 
        python-eventlib = with final; python3.pkgs.buildPythonPackage rec {
          pname = "python-eventlib";
          version = "0.2.5";

          src = python-eventlib-src;

          propagatedBuildInputs = with  python3Packages; [
            twisted
            eventlet
          ];

          doCheck = false;

          meta = with lib; {
            description = "Netowork lib";
            homepage = https://github.com/AGProjects/python3-eventlib;
            license = licenses.lgpl2Plus;
          };
        };

         python-msrplib = with final; python3.pkgs.buildPythonPackage rec {
          pname = "python-msrplib";
          version = "0.21.0";
          
          buildInputs = [
          pkgs.gnutls
          ];
          src = python3-msrplib-src;
          

          propagatedBuildInputs = [
            (python3.withPackages
            (ps: with ps; [
            lxml
            python-eventlib
            gevent
            python-gnutls
            final.application
          ]))
          ];


          meta = with lib; {
            description = "Netowork lib";
            homepage = https://github.com/AGProjects/python3-eventlib;
            license = licenses.lgpl2Plus;
          };
        };

          python-xcaplib = with final; python3.pkgs.buildPythonPackage rec {
          pname = "python-xcaplib";
          version = "2.0.1";

          src = python3-xcaplib-src;


          doCheck = true;

          checkInputs =[
            (python3.withPackages
            (ps: with ps; [
              python-eventlib
              gevent
              lxml 
              python-gnutls
              final.application
            ]))];

          meta = with lib; {
            description = "Netowork lib";
            homepage = https://github.com/AGProjects/python3-xcaplib;
            license = licenses.lgpl2Plus;
          };
        };

 
 
 
        application = with final; python3.pkgs.buildPythonPackage rec {
          pname = "application";
          version = "3.0.3";

          src = python-application-src;


          propagatedBuildInputs = with  python3Packages; [
            zope_interface
            twisted
            setuptools
          ];
          
          doCheck = true;

          meta = with lib; {
            description = "Basic building blocks for python applications";
            homepage = https://github.com/AGProjects/python-application;
            license = licenses.lgpl2Plus;
          };
        };

 
       python-otr-ag = with final; python3.pkgs.buildPythonPackage rec {
          pname = "python-otr-ag";
          version = "1.0.2";

          src = python-otr-src;

          propagatedBuildInputs = [
            (python3.withPackages
            (ps: with ps; [
            enum34
            gmpy2
            zope_interface
            cryptography
            final.application
          ])) ];
         patchPhase = ''
           substituteInPlace setup.py --replace "['gmpy2', 'zope.interface', 'application', 'cryptography']" "['gmpy2', 'zope.interface','cryptography']"
         '';
 
          doCheck = false;

          meta = with lib; {
            description = "AGProjects python3-otr";
            homepage = https://github.com/python-otr/pure-python-otr;
            license = licenses.lgpl2Plus;
          };
        };

        python-sipsimple = with final; python3.pkgs.buildPythonPackage rec {
          pname = "python-sipsimple";
          version = "5.2.6";
  
          src = python-sipsimple-src;

           preConfigure = ''
            chmod +x ./deps/pjsip/configure ./deps/pjsip/aconfigure
            export LD=$CC
           '';


          nativeBuildInputs = [ wget pkgs.pkgconfig ];

          buildInputs = with pkgs; [ openssl.dev alsaLib ffmpeg libv4l sqlite libvpx python3Packages.cython ];

          propagatedBuildInputs = [
            (python3.withPackages
            (ps: with ps; [
            autobahn
            openssl
            lxml
            twisted
            dateutil
            greenlet
            python-xcaplib
            python-msrplib
            python-gnutls
            final.application
            python-eventlib
            python-otr-ag
            gevent
            pkg-config
            setuptools
          ]))
          ];


          doCheck = false;

          meta = with lib; {
            description = "SIP Simple Client SDK";
            homepage = https://github.com/AGProjects/python-sipsimple;
            license = licenses.lgpl2Plus;
          };
        };


        sylk-server = with final; python3.pkgs.buildPythonApplication rec {
          pname = "sylk-server";
          version = "5.7.0";

          src = python-sylkserver-src;

          propagatedBuildInputs = [
            (python3.withPackages
            (ps: with ps; [
        
            setuptools
            python-sipsimple
            final.application
            lxml
            twisted
            klein
            autobahn
            werkzeug
            python-gnutls
            python-eventlib
            python-xcaplib
            dateutil
            gevent
            python-msrplib
            python-otr-ag
            gmpy2
            python-wokkel
          ]))
          ];

          doCheck = false;

          meta = with lib; {
            description = "SIP Simple Client SDK";
            homepage = https://github.com/AGProjects/python-sipsimple;
            license = licenses.lgpl2Plus;
          };
        };
      };


      packages = forAllSystems (system:
        {
          inherit (nixpkgsFor.${system}) sylk-server;
        });

      defaultPackage = forAllSystems (system: self.packages.${system}.sylk-server);


    };
}
