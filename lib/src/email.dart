import 'package:linkify/linkify.dart';

final _emailRegex = RegExp(
  r'^(.*?)((mailto:)?[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z][A-Z]+)',
  caseSensitive: false,
  dotAll: true,
);
final _mentionRegex = RegExp(
  r'\@[a-zA-Z0-9]+\b()',
  caseSensitive: false,
  dotAll: true,
);
final _userTagRegex = RegExp(
  r'^(.*?)(?<![\w@])@([\w@]+(?:[.!][\w@]+)*)',
  caseSensitive: false,
  dotAll: true,
);

class EmailLinkifier extends Linkifier {
  const EmailLinkifier();

  @override
  List<LinkifyElement> parse(elements, options,listMentionIds) {
    final list = <LinkifyElement>[];

    elements.forEach((element) {
      if (element is TextElement) {
        final match = _emailRegex.firstMatch(element.text);

        if (match == null) {
          list.add(element);
        } else {
          final text = element.text.replaceFirst(match.group(0)!, '');

          if (match.group(1)?.isNotEmpty == true) {
            list.add(TextElement(match.group(1)!));
          }

          if (match.group(2)?.isNotEmpty == true) {
            // Always humanize emails
            list.add(EmailElement(
              match.group(2)!.replaceFirst(RegExp(r'mailto:'), ''),
            ));
          }

          if (text.isNotEmpty) {
            list.addAll(parse([TextElement(text)], options,listMentionIds));
          }
        }
      } else {
        list.add(element);
      }
    });

    return list;
  }
}

/// Represents an element containing an email address
class EmailElement extends LinkableElement {
  final String emailAddress;

  EmailElement(this.emailAddress) : super(emailAddress, 'mailto:$emailAddress');

  @override
  String toString() {
    return "EmailElement: '$emailAddress' ($text)";
  }

  @override
  bool operator ==(other) => equals(other);

  @override
  bool equals(other) =>
      other is EmailElement &&
      super.equals(other) &&
      other.emailAddress == emailAddress;
}

class MentionLinkifier extends Linkifier {
  const MentionLinkifier();

  @override
  List<LinkifyElement> parse(elements, options,listMentionIds) {
    final list = <LinkifyElement>[];
  final  _mentionRegex=RegExp('$listMentionIds');
    for (var element in elements) {
      if (element is TextElement &&listMentionIds.isNotEmpty) {
        element.text .splitMapJoin(
          _mentionRegex,
    onMatch: (Match m) {
      list.add(MentionElement(m.group(0)!));
return m[0]!;
    },

    ///[1,3,e
    onNonMatch: (String span) {
      list.add(TextElement(span));
      return span;

    }
    );
        ///////////////////
        // final match = _mentionRegex.firstMatch(element.text);
        //
        // if (match == null) {
        //   list.add(element);
        // } else {
        //   final text = element.text.replaceFirst(match.group(0)!, '');
        //
        //   if (match.group(0)?.isNotEmpty == true) {
        //     list.add(MentionElement(match.group(0)!));
        //   }
        //
        //   // if (match.group(1)?.isNotEmpty == true) {
        //   //   list.add(MentionElement('@${match.group(1)!}'));
        //   // }
        //
        //   if (text.isNotEmpty) {
        //     list.addAll(parse([TextElement(text)], options,listMentionIds));
        //   }
        // }
        /////////////////////
        // final matchs = _userTagRegex.firstMatch(element.text);
        // print(matchs);
        // final match = _mentionRegex.allMatches(element.text);
        // if (match.isEmpty) {
        //   list.add(element);
        // } else
        // {
        //   // list.add(MentionElement(element.text));
        //
        //   // if (match.group(0)?.isNotEmpty==true) {
        //   //     list.add(MentionElement(match.group(0)!));
        //   //   }
        //   //   else{
        //   //     list.add(element);
        //   //
        //   //   }
        //
        //     for (var entry in match) {
        //       if (entry
        //           .group(0)
        //           ?.isNotEmpty == true) {
        //         list.add(MentionElement(entry.group(0)!));
        //       }
        //       else {
        //         list.add(element);
        //       }
        //
        //   }
        // }
      // if(listMentionIds.contains(element.text)){
      //       list.add(MentionElement(element.text));
      //
      // }else{
      //   list.add(element);
      // }
        // final match = _mentionRegex.allMatches(element.text);
        // for (var entry in match) {
        //   if (entry.group(0) != null) {
        //     list.add(MentionElement(entry.group(0)!));
        //   }
        // }
      }
      else {
        list.add(element);
      }
    }

    return list;
  }
}

/// Represents an element containing an email address
class MentionElement extends MentionText {
  final String mention;

  MentionElement(this.mention) : super(mention);

  @override
  String toString() {
    return "MentionElement: '$mention' ($text)";
  }

  @override
  bool operator ==(other) => equals(other);

  @override
  bool equals(other) =>
      other is MentionElement &&
          super.equals(other) &&
          other.mention == mention;
}
