#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <dlfcn.h>
#include <sys/mount.h>

#include <global.h>
#include <neutrino.h>
#include <gui/widget/icons.h>
#include "gui/widget/menue.h"
#include "gui/widget/stringinput.h"
#include "gui/widget/messagebox.h"
#include "gui/widget/hintbox.h"
#include "gui/widget/progresswindow.h"

#include "system/setting_helpers.h"
#include "system/settings.h"
#include "system/debug.h"
#include <dvb-ci.h>
#include <sectionsd/edvbstring.h>

#include <driver/encoding.h>
#include <driver/framebuffer.h>
#include <driver/fontrenderer.h>
#include <driver/rcinput.h>
#include <driver/stream2file.h>
#include <driver/vcrcontrol.h>
#include <driver/shutdown_count.h>
#include <driver/screen_max.h>

#include "teamcsupnp.h"

////////////////////////////// Extra Menu ANFANG ////////////////////////////////////

teamcsupnp::teamcsupnp()
{
   frameBuffer = CFrameBuffer::getInstance();
   width = 600;
   hheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU_TITLE]->getHeight();
   mheight = g_Font[SNeutrinoSettings::FONT_TYPE_MENU]->getHeight();
   height = hheight+13*mheight+ 10;

   x=(((g_settings.screen_EndX- g_settings.screen_StartX)-width) / 2) + g_settings.screen_StartX;
   y=(((g_settings.screen_EndY- g_settings.screen_StartY)-height) / 2) + g_settings.screen_StartY;
}


int teamcsupnp::exec(CMenuTarget* parent, const std::string &actionKey)
{
   int res = menu_return::RETURN_REPAINT;
   int shortcutTeamCS = 1;
   FILE *cprompt;
   char ctext [4096];
   char cprompthint[4096]={0};
   neutrino_msg_t      msg;
   neutrino_msg_data_t data;
   unsigned long long TimeoutEnd;


   if (parent)
   {
      parent->hide();
   }
   paint();

  if (actionKey.empty())
  {
      //Menu aufbauen
      CMenuWidget* teamcsupnp = new CMenuWidget(LOCALE_TEAMCS_HEAD, NEUTRINO_ICON_SETTINGS);
	teamcsupnp->addItem(GenericMenuBack);
        teamcsupnp->addItem( new CMenuSeparator(CMenuSeparator::LINE) );

      teamcsupnp->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUPNP_AN, true, "", this, "an", CRCInput::RC_red, NEUTRINO_ICON_BUTTON_RED, "nix", LOCALE_HELPTEXT_NIX));
      teamcsupnp->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUPNP_AUS, true, "", this, "aus", CRCInput::RC_green, NEUTRINO_ICON_BUTTON_GREEN, "nix", LOCALE_HELPTEXT_NIX));
      teamcsupnp->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUPNP_AUTOAN, true, "", this, "autoan", CRCInput::RC_yellow, NEUTRINO_ICON_BUTTON_YELLOW, "nix", LOCALE_HELPTEXT_NIX));
      teamcsupnp->addItem( new CMenuForwarderItemMenuIcon(LOCALE_TEAMCSUPNP_AUTOAUS, true, "", this, "autoaus", CRCInput::RC_blue, NEUTRINO_ICON_BUTTON_BLUE, "nix", LOCALE_HELPTEXT_NIX));

      teamcsupnp->exec (NULL, "");
      teamcsupnp->hide ();
      delete teamcsupnp;

      
   }
   else if (actionKey == "an")
   {
      //CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, g_Locale->getText(LOCALE_SERVICEMENU_GETPLUGINS_HINT));

      	system("/bin/djmount -f /upnp &");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "UPNP Client Gestartet, Daten koennen in upnp Ordner abgerufen werden");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }	
   else if (actionKey == "aus")
   {

      	system("killall -9 djmount");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "UPNP Client Gestoppt");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }
   else if (actionKey == "autoan")
   {

      	system("echo upnpan > /var/keys/Benutzerdaten/.system/upnp");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "UPNP Client Autostart Aktiviert");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;   
   }
   else if (actionKey == "autoaus")
   {

      	system("echo upnpaus > /var/keys/Benutzerdaten/.system/upnp");
      	CHintBox * hintBox = new CHintBox(LOCALE_MESSAGEBOX_INFO, "UPNP Client Autostart Deaktiviert");	
      	hintBox->paint();

		while( msg != CRCInput::RC_ok )
		{
		g_RCInput->getMsgAbsoluteTimeout( &msg, &data, &TimeoutEnd );
		usleep(5000);
		}

      	hintBox->hide();
      	delete hintBox;
   }

   return res;
}


void teamcsupnp::hide()
{
   frameBuffer->paintBackgroundBoxRel(x,y, width,height);
}


void teamcsupnp::paint()
{
   printf("$Id: Menu Exp $\n");
}


////////////////////////////// Extra Menu ENDE //////////////////////////////////////