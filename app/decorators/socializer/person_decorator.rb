#
# Namespace for the Socializer engine
#
module Socializer
  # Decorators for {Socializer::Person}
  class PersonDecorator < ApplicationDecorator
    delegate_all

    # Define presentation-specific methods here. Helpers are accessed through
    # `helpers` (aka `h`). You can override attributes, for example:
    #
    #   def created_at
    #     helpers.content_tag :span, class: "time" do
    #       object.created_at.strftime("%a %m/%d/%y")
    #     end
    #   end

    #  Attributes

    # Format the birthdate attribute
    #
    # @return [String]
    def birthdate
      model.birthdate? ? model.birthdate.to_s(:long_ordinal) : nil
    end

    # Returns the capitalized gender
    #
    # @return [String]
    def gender
      model.gender.titleize
    end

    # Returns the occupation value or "What do you do?" when occupation is nil
    #
    # @return [String]
    def occupation
      model.occupation || "What do you do?"
    end

    # Returns the other_names value or "For example: maiden name, alternate
    # spellings"
    #
    # @return [String]
    def other_names
      model.other_names || "For example: maiden name, alternate spellings"
    end

    # Returnes the capitalized relationship or "Seeing anyone?" if the
    # relationship value is unknown
    #
    # @return [String]
    def relationship
      relationship = model.relationship

      return "Seeing anyone?" if relationship.unknown?
      relationship.titleize
    end

    # Returns the skills value or "What are your skills?" when skills is nil
    #
    # @return [String]
    def skills
      model.skills || "What are your skills?"
    end

    # The location/url of the persons avatar
    #
    # @example
    #   current_user.avatar_url
    #
    # @return [String]
    #
    def avatar_url
      avatar_providers = %w( FACEBOOK LINKEDIN TWITTER )

      return social_avatar_url if avatar_providers.include?(avatar_provider)

      gravatar_url
    end

    # The number of contacts for the decorated {Socializer::Person}
    #
    # @return [String]
    def contacts_count
      helpers.pluralize(model.contacts_count, "person")
    end

    # The number of {Socializer::Person people} this Socializer::Person person}
    # is a contact of
    #
    # @return [String]
    def contact_of_count
      helpers.pluralize(model.contact_of.count, "person")
    end

    # Creates an image tag for the persons avatar
    #
    # @param size: nil [String]
    # @param css_class: nil [String]
    # @param alt: "Avatar" [String]
    # @param title: nil [String]
    #
    # @return [String]  An HTML image tag
    def image_tag_avatar(size: nil, css_class: nil, alt: "Avatar", title: nil)
      helpers.image_tag(avatar_url, size: size, class: css_class, alt: alt,
                                    title: title,
                                    data: { behavior: "tooltip-on-hover" })
    end

    # Creates a link to the persons profile with their avatar as the content
    #
    # @return [String] An HTML a tag
    def link_to_avatar
      helpers.link_to(image_tag_avatar(title: model.display_name),
                      helpers.person_activities_path(person_id: model.id))
    end

    # Returns what relationships the {Socializer::Person person} is looking for
    #
    # @return [String]
    def looking_for
      looking_for = ""
      looking_for << "Friends<br>" if model.looking_for_friends
      looking_for << "Dating<br>" if model.looking_for_dating
      looking_for << "Relationship<br>" if model.looking_for_relationship
      looking_for << "Networking<br>" if model.looking_for_networking
      looking_for << "Who are you looking for?" if looking_for.empty?

      looking_for
    end

    # Builds the links for the shared toolbar
    #
    # @return [String] the html needed to display the toolbar links
    def toolbar_stream_links
      list = combine_circles_and_memberships
      return if list.blank?

      html = []
      html << toolbar_links(list[0..2])
      html << toolbar_dropdown(list[3..(list.size)])

      html.join.html_safe
    end

    private

    def combine_circles_and_memberships
      model.circles + model.memberships
    end

    def social_avatar_url
      auth = authentications.find_by(provider: avatar_provider.downcase)
      auth.image_url if auth.present?
    end

    def gravatar_url
      return if email.blank?
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
    end

    def toolbar_dropdown(list)
      helpers.content_tag(:li, class: "dropdown") do
        dropdown_link +
          helpers.content_tag(:ul, class: "dropdown-menu") do
            toolbar_links(list)
          end
      end
    end

    def dropdown_link
      css_class = "dropdown-toggle"
      icon      = helpers.content_tag(:span, nil,
                                      class: "fa fa-angle-down fa-fw")

      helpers.link_to("#", class: css_class, data: { toggle: "dropdown" }) do
        # i18n-tasks-use t("socializer.shared.toolbar.more")
        "#{helpers.t('socializer.shared.toolbar.more')} #{icon}".html_safe
      end
    end

    # Check if the url is the current page
    #
    # @param url: [String] The url to check
    #
    # @return [String/Nil] Returns "active" if the url is the current page.
    def toolbar_item_class(url:)
      "active" if helpers.current_page?(url)
    end

    def toolbar_links(list)
      list.map do |item|
        toolbar_link(item)
      end.join.html_safe
    end

    # Check if the object is an instance of {Socializer::Membership}
    #
    # @param object:
    #
    # @return [Socializer::Group]
    def toolbar_object(object:)
      return object.group if object.is_a?(Socializer::Membership)
      object
    end

    def toolbar_link(item)
      item       = toolbar_object(object: item)
      url_prefix = item.class.name.demodulize.downcase
      url        = helpers.public_send("#{url_prefix}_activities_path", item.id)
      class_name = toolbar_item_class(url: url)

      helpers.content_tag(:li) do
        helpers.link_to(item.display_name, url, class: class_name)
      end
    end
  end
end
