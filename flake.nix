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
    url = github:AGprojects/python3-sipsimple;
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

          propagatedBuildInputs = [
            python3Packages.twisted
            python3Packages.pyopenssl
            python3Packages.service-identity
          ];
          doCheck=false;
          checkInputs = [
           gnutls
          ];

          meta = with lib; {
            description = "Python wrapper for the GnuTLS Library";
            homepage = https://github.com/AGProjects/python-gnutls;
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

          src = python3-msrplib-src;
          propagatedBuildInputs = [
            (python3.withPackages
            (ps: with ps; [
            lxml
            python-eventlib
            gevent
          ]))
          ];


          doCheck = true;

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
              python-application-ag
            ]))];

          meta = with lib; {
            description = "Netowork lib";
            homepage = https://github.com/AGProjects/python3-xcaplib;
            license = licenses.lgpl2Plus;
          };
        };

 
 
 
        python-application-ag = with final; python3.pkgs.buildPythonPackage rec {
          pname = "python-application";
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
            python-application-ag  
            enum34
            gmpy2
            zope_interface
            cryptography
          ])) ];

          doCheck = true;

          meta = with lib; {
            description = "AGProjects python3-otr";
            homepage = https://github.com/python-otr/pure-python-otr;
            license = licenses.lgpl2Plus;
          };
        };

        python-sipsimple = with final; python3.pkgs.buildPythonPackage rec {
          pname = "python-sipsimple";
          version = "3.6.0";
          preConfigure = ''
            chmod +x ./deps/pjsip/configure ./deps/pjsip/aconfigure
            export LD=$CC
          '';
          src = python-sipsimple-src;

          nativeBuildInputs = [ pkgs.pkgconfig ];

          buildInputs = with pkgs; [ openssl.dev alsaLib ffmpeg libv4l sqlite libvpx python3Packages.cython ];

          propagatedBuildInputs = [
            (python3.withPackages
            (ps: with ps; [
            autobahn
            openssl
            dnspython_1
            lxml
            twisted
            dateutil
            greenlet
            python-xcaplib
            python-msrplib
            python-gnutls
            python-application-ag
            python-eventlib
            python-otr-ag
            pkg-config
            setuptools
          ]))
          ];


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
            python-application-ag
            lxml
            twisted
            klein
            autobahn
            typing
            werkzeug
          ]))
          ];


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
