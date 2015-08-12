package hpsa.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class BaseController extends GenericController {

	@RequestMapping(value = "/home")
	public ModelAndView getHomePage() {
		ModelAndView view = getBasicPage();
		view.setViewName("home");

		return view;
	}

}
