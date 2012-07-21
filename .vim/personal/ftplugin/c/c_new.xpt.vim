XPTemplate priority=personal+
XPTinclude
      \ _common/common
      \ _preprocessor/c.like


XPT aptgui " shortcut for some code 
#ifdef SE_GUI
`cursor^
#else
#endif /* SE_GUI */

" Krzysztof Kanas home common C headers templates

XPT beerware " beerware licence 
XSET cursor|pre=CURSOR
/**
 * @file        :  `file()^ 
 * @author      :  `$author^ | `$email^
 * @description :
 * @Copyrigths  :  `date()^
 * 
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <`$email^> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return `$author^. 
 *     `cursor^
 * 
 */

XPT kelvatek " kelvatek licence
/**
 * @file        :  `file()^ 
 * @author      :  `$kelvatek_author^ | `$kelvatek_email^
 * @Company     :  Kelvatek 
 * @Copyrigths  :  Kelvatek  `strftime("%Y")^
 * @description : `cursor^ 
 *
 */

XPT doxy " doxygen documentation 
/**
 *  @brief `birief^ 
 *  @param `param1^
 *  @return `return^
 *  @warning `warning^
 *  `cursor^ 
*/
