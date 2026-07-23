describe('Smoke Test', () => {
  it('loads homepage and shows main heading', () => {
    cy.visit('/');
    cy.get('h1, h2, [role="heading"]').first().should('be.visible');
  });

  it('page title is not empty', () => {
    cy.visit('/');
    cy.title().should('not.be.empty');
  });

  it('body element exists without errors', () => {
    cy.visit('/');
    cy.get('body').should('exist');
  });
});
