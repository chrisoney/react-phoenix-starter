import Cookies from 'universal-cookie'

export const setAuthToken = (token) => {
  const cookies = new Cookies();
  cookies.set('my_auth_token', token, {
      path: '/'
  });
};

export const getAuthToken = () => {
  const cookies = new Cookies();
  return cookies.get('my_auth_token');
};
export const removeAuthToken = () => {
  const cookies = new Cookies();
  cookies.remove('my_auth_token', {
      path: '/',
  });
};

export const authFetch = (url, options) => (
  fetch(url, mergeAuthHeaders(options)).then(
      response => {
          // Sign out if we receive a 401!
          return response;
      },
      error => error
  )
);
const mergeAuthHeaders = (baseOptions) => {
  const options = baseOptions ===  undefined ? {} : baseOptions;
  if (!options['headers']) {
      options.headers = {};
  }
  options.headers = {
      ...options.headers,
      'Authorization': `Bearer ${getAuthToken()}`,
  };
  return options;
}