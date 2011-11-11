# -*- coding: utf-8 -*-
module Lang
   def Lang.getLang(lang)
     if lang == 'en' 
       {'title' => 'Browser Fingerprinting',
         'title_info' => "<p>
	This webpage is part of a Master's Thesis project, with the purpose of 
        collecting data from web browsers. The goal of the project is
	to develop a method for determining the uniqueness of browsers, without
	using intrusive methods such as cookies. We will attempt to do this by
	looking at information about your browser, such as screen resolution,
	installed fonts, browser version, etc. This information constitutes
	your <i>browser fingerprint</i>. Find out more about the project and us
	by clicking the <span class=\"blue\">About</span> button.
      </p>
      <p>
	We would greatly appreciate if you would take the time to share your
	data with us by clicking the <span class=\"green\">Submit</span> button
	below. If you're interested in what type of data we're interested in 
        and are collecting, you can see your <i>fingerprint</i> by clicking
	the <span class=\"orange\">Preview</span> button.
      </p>
      <p>
	Upon clicking <span class=\"green\">Submit</span>, you agree to sharing
	your <i>fingerprint</i> with us and letting us store it for research
	purposes in out thesis work. No data will, under any circumstances, 
        be used for commercial purposes nor shared with others.
      </p>
      <p>
        This webpage is not affiliated in any way with Burt Corp.
      </p>",
         'switch_language'  => "<a href=\"/sv\">På svenska</a>",
         'button_about'     => "About",
         'button_preview'   => "Preview",
         'button_submit'    => "Submit",
         'your_fingerprint' => "Your fingerprint",
         'submit_error'     => 'An error occurred! We are sorry for the inconvenience, please try again later!',
         'thankyou_msg'     => 'Thank you for your data, please come back again in a day or two.'
       }
     else
       {'title' => 'Browser Fingerprinting',
         'title_info' => "<p>
	Denna webbsida är en del av ett exjobb och dess syfte är att samla in data 
        från webbläsare. Målet med projektet är att utveckla en metod för att avgöra om
	en webbläsare är unik, utan att använda inkräktande metoder såsom
	kakor. Vi försöker göra detta genom att enbart titta på information om
	din webbläsare, såsom skärmupplösning, installerade typsnitt,
	webbläsarversion, osv. Denna information utgör vad vi kallar
	ditt <i>fingeravtryck</i>. Du kan läsa mer om vårt projekt och oss genom
	att klicka på knappen <span class=\"blue\">Om projektet</span>.
      </p>
      <p>
	Vi hoppas att du kan ta dig tid att dela med dig av ditt fingeravtryck
	till oss, genom att klicka på knappen <span class=\"green\">Skicka in</span>
	nedan. Om du är intresserad av att se vilken information vi är intresserade 
        av och samlar in kan du klicka på knappen 
        <span class=\"orange\">Granska data</span>.
      </p>
      <p>
	När du klickar på <span class=\"green\">Skicka in</span> godkänner
	du att vi sparar ditt <i>fingeravtryck</i> för att använda i vår
	forskning. Din data kommer inte, under några som helst omständigheter,
        att användas för kommersiella syften eller delas med utomstående.
      </p>
      <p>
        Denna webbsida är inte kopplad till Burt AB på något sätt.
      </p>",
         'switch_language'  => "<a href=\"/en\">In english</a>",
         'button_about'     => "Om projektet",
         'button_preview'   => "Granska data",
         'button_submit'    => "Skicka in data",
         'your_fingerprint' => "Ditt fingeravtryck",
         'submit_error'     => 'Ett fel inträffade! Vi ber om ursäkt för detta, var vänlig och försök igen senare!',
         'thankyou_msg'     => 'Tack för din medverkan, kom gärna tillbaka igen om en dag eller två.'
       }

     end
   end
end