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

package org.jtalks.jcommune.plugin.kaptcha;

import com.google.code.kaptcha.Constants;
import com.google.code.kaptcha.Producer;
import org.jtalks.jcommune.model.dto.UserDto;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.image.BufferedImage;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import static org.mockito.Mockito.*;
import static org.testng.Assert.*;

public class KaptchaPluginServiceTest {

    private final String GENERATED_CAPTCHA_TEXT = "2356";
    private final int IMAGE_WIDTH = 100;
    private final int IMAGE_HEIGHT= 50;
    private final int IMAGE_LENGTH= 50;
    private final String POSSIBLE_SYMBOLS = "1234567890";

    private KaptchaPluginService service;

    @BeforeMethod
    public void setUp() throws Exception {
        service = spy(new KaptchaPluginService(IMAGE_WIDTH, IMAGE_HEIGHT, IMAGE_LENGTH, POSSIBLE_SYMBOLS));
    }

    @Test
    public void testNoCoincidenceCaptchaWithInputValue() throws Exception {
        UserDto userDto = createUserDto();
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpSession session = new MockHttpSession();
        String captchaText = "1234";
        session.setAttribute(Constants.KAPTCHA_SESSION_KEY, captchaText);
        request.setSession(session);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));

        Map<String, String> errors = service.validateCaptcha(userDto, 1L);

        assertFalse(errors.isEmpty(), "Validation of captcha with valid value should not return any errors.");
    }

    @Test
    public void testCoincidenceCaptchaWithInputValue() throws Exception {
        UserDto userDto = createUserDto();
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpSession session = new MockHttpSession();
        session.setAttribute(Constants.KAPTCHA_SESSION_KEY, GENERATED_CAPTCHA_TEXT);
        request.setSession(session);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));

        Map<String, String> errors = service.validateCaptcha(userDto, 1L);

        assertTrue(errors.isEmpty(), "Validation of captcha with valid value should not return any errors.");
    }

    private UserDto createUserDto() {
        UserDto userDto = new UserDto();
        Map<String, String> captchas = new HashMap<>();
        captchas.put("plugin-1", GENERATED_CAPTCHA_TEXT);
        captchas.put("plugin-2", "2222");
        captchas.put("plugin-3", "3333");
        userDto.setCaptchas(captchas);
        return userDto;
    }

    private Properties createProperties() {
        Properties properties = new Properties();
        properties.put("resource.loader", "class");
        properties.put("class.resource.loader.class", "org.apache.velocity.runtime.resource.loader.ClasspathResourceLoader");
        return properties;
    }

    @Test(enabled = false)
    public void testGetHtml() throws Exception {
        Properties properties = createProperties();
        HttpServletRequest request = mock(HttpServletRequest.class);
        when(service.getProperties()).thenReturn(properties);
        String expected = "<div class='control-group'>\n" +
                "  <div class='controls captcha-images'>\n" +
                "    <img class='captcha-img' alt='Captcha' src='http://localhost:8080/plugin/1/refreshCaptcha'/>\n" +
                "    <img class='captcha-refresh' alt='Refresh captcha' src='http://localhost:8080/resources/images/captcha-refresh.png'/>\n" +
                "  </div>\n" +
                "  <div class='controls'>\n" +
                "    <input type='text' id='plugin-1' name='userDto.captchas[plugin-1]' placeholder='Captcha text' class='input-xlarge captcha'/>\n" +
                "  </div>\n" +
                "</div>";

        String actual = service.getHtml(request, "1", Locale.ENGLISH);
        assertSame(actual, expected);
    }

    @Test(enabled = false)
    public void testHandleRequestToCaptchaImage() throws Exception {
        HttpServletResponse response = mock(HttpServletResponse.class);
        ServletOutputStream out = mock(ServletOutputStream.class);
        HttpSession session = mock(HttpSession.class);
        Producer captchaProducer = mock(Producer.class);

        int imageType = 1;
        when(captchaProducer.createText()).thenReturn(GENERATED_CAPTCHA_TEXT);
        when(captchaProducer.createImage(GENERATED_CAPTCHA_TEXT)).
                thenReturn(new BufferedImage(IMAGE_WIDTH, IMAGE_HEIGHT, imageType));

        service.handleRequestToCaptchaImage(response, out, session);

        verify(response).setContentType("image/jpeg");
        verify(session).setAttribute(Constants.KAPTCHA_SESSION_KEY, GENERATED_CAPTCHA_TEXT);
    }
}