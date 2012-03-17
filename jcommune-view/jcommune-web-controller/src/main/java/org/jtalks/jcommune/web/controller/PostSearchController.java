/**
 * Copyright (C) 2011  JTalks.org Team
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */
package org.jtalks.jcommune.web.controller;

import java.util.List;

import org.jtalks.jcommune.model.entity.JCUser;
import org.jtalks.jcommune.model.entity.Post;
import org.jtalks.jcommune.service.PostSearchService;
import org.jtalks.jcommune.service.nontransactional.SecurityService;
import org.jtalks.jcommune.web.util.Pagination;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 * The controller for the full-text search posts.
 * 
 * @author Anuar Nurmakanov
 *
 */
@Controller
public class PostSearchController {
	private PostSearchService postSearchService;
	private SecurityService securityService;
	
	/**
	 * Constructor for controller instantiating, dependencies injected via autowiring.
	 * 
	 * @param postSearchService {@link PostSearchService} instance to be injected
	 * @param securityService {@link SecurityService} instance to be injected
	 */
	@Autowired
	public PostSearchController(PostSearchService postSearchService, SecurityService securityService) {
		this.postSearchService = postSearchService;
		this.securityService = securityService;
	}
	
	/**
	 * Full-text search for posts. It needed to start the search.
	 * 
	 * @param searchText search text
	 * @return redirect to answer page
	 */
	@RequestMapping(value = "/search", method = RequestMethod.GET)
	public ModelAndView initSearch(@RequestParam String searchText) {
		int firstPage = 1; 
		return search(searchText, firstPage);
	}
	
	/**
	 * Full-text search for posts. It needed to continue the search.
	 * 
	 * @param searchText search text
	 * @param page page number
	 * @return redirect to answer page
	 */
	@RequestMapping(value = "/search/{searchText}", method = RequestMethod.GET)
	public ModelAndView continueSearch(@PathVariable String searchText,
			@RequestParam(value = "page", defaultValue = "1", required = false) Integer page) {
		return search(searchText, page);
	}
	
	private ModelAndView search(String searchText, int page) {
		JCUser currentUser = securityService.getCurrentUser();
		List<Post> posts = postSearchService.searchPostsByPhrase(searchText);
		String uri = searchText;
		Pagination pagination = new Pagination(page, currentUser, posts.size(), true);
		return new ModelAndView("postSearchResult").
				addObject("posts", posts).
				addObject("pagination", pagination).
				addObject("uri", uri).
				addObject("searchText", searchText);
	}
}
