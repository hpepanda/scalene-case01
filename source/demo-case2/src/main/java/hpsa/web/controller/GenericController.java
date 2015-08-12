package hpsa.web.controller;

import hpsa.service.util.IPAddressUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;

public class GenericController {

	@Autowired
	IPAddressUtil ipUtil;

	protected ModelAndView getBasicPage() {
		ModelAndView view = new ModelAndView();
		view.addObject("ip", ipUtil.getLocalIp());
		return view;
	}
}