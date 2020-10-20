import { toFixed } from 'common/math';
import { classes } from 'common/react';
import { storage } from 'common/storage';
import { multiline } from 'common/string';
<<<<<<< HEAD:tgui-next/packages/tgui/interfaces/CentcomPodLauncher.js
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section } from '../components';

// This is more or less a direct port from old tgui, with some slight
// text cleanup. But yes, it actually worked like this.
export const CentcomPodLauncher = props => {
  const { act, data } = useBackend(props);
=======
import { createUuid } from 'common/uuid';
import { Component } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, ByondUi, Divider, Flex, Fragment, Input, Knob, LabeledControls, NumberInput, Section } from '../components';
import { Window } from '../layouts';

const pod_grey = {
  color: 'grey',
};

const useCompact = context => {
  const [compact, setCompact] = useLocalState(context, 'compact', false);
  const toggleCompact = () => setCompact(!compact);
  return [compact, toggleCompact];
};

export const CentcomPodLauncher = (props, context) => {
  const [compact] = useCompact(context);
  return (
    <Window
      resizable
      key={'CPL_' + compact}
      title={compact
        ? "Use against Helen Weinstein"
        : "Supply Pod Menu (Use against Helen Weinstein)"}
      overflow="hidden"
      width={compact ? 435 : 690}
      height={compact ? 360 : 440}>
      <CentcomPodLauncherContent />
    </Window>
  );
};

const CentcomPodLauncherContent = (props, context) => {
  const [compact] = useCompact(context);
  return (
    <Window.Content>
      <Flex direction="column" height="100%">
        <Flex.Item grow={0} shrink={0}>
          <PodStatusPage />
        </Flex.Item>
        <Flex.Item mt={1} grow={1}>
          <Flex height="100%">
            <Flex.Item grow={1} shrink={0} basis="13em">
              <Flex direction="column" height="100%" >
                <Flex.Item grow={1}>
                  <PresetsPage />
                </Flex.Item>
                <Flex.Item mt={1} grow={0}>
                  <ReverseMenu />
                </Flex.Item>
                <Flex.Item mt={1}>
                  <Section>
                    <LaunchPage />
                  </Section>
                </Flex.Item>
              </Flex>
            </Flex.Item>
            {!compact && (
              <Flex.Item ml={1} grow={3}>
                <ViewTabHolder />
              </Flex.Item>
            )}
            <Flex.Item ml={1} basis="8em">
              <Flex direction="column" height="100%">
                <Flex.Item>
                  <Bays />
                </Flex.Item>
                <Flex.Item mt={1} grow={1}>
                  <Timing />
                </Flex.Item>
                {!compact && (
                  <Flex.Item mt={1}>
                    <Sounds />
                  </Flex.Item>
                )}
              </Flex>
            </Flex.Item>
            <Flex.Item ml={1} basis="11em">
              <StylePage />
            </Flex.Item>
          </Flex>
        </Flex.Item>
      </Flex>
    </Window.Content>
  );
};

const TABPAGES = [
  {
    title: 'View Pod',
    component: () => TabPod,
  },
  {
    title: 'View Bay',
    component: () => TabBay,
  },
  {
    title: 'View Dropoff Location',
    component: () => TabDrop,
  },
];

const REVERSE_OPTIONS = [
  {
    title: 'Mobs',
    icon: 'user',
  },
  {
    title: 'Unanchored\nObjects',
    key: 'Unanchored',
    icon: 'cube',
  },
  {
    title: 'Anchored\nObjects',
    key: 'Anchored',
    icon: 'anchor',
  },
  {
    title: 'Under-Floor',
    key: 'Underfloor',
    icon: 'eye-slash',
  },
  {
    title: 'Wall-Mounted',
    key: 'Wallmounted',
    icon: 'link',
  },
  {
    title: 'Floors',
    icon: 'border-all',
  },
  {
    title: 'Walls',
    icon: 'square',

  },
];


const DELAYS = [
  {
    title: 'Pre',
    tooltip: 'Time until pod gets to station',
  },
  {
    title: 'Fall',
    tooltip: 'Duration of pods\nfalling animation',
  },
  {
    title: 'Open',
    tooltip: 'Time it takes pod to open after landing',
  },
  {
    title: 'Exit',
    tooltip: 'Time for pod to\nleave after opening',
  },
];

const SOUNDS = [
  {
    title: 'Fall',
    act: 'fallingSound',
    tooltip: 'Plays while pod falls, timed\nto end when pod lands',
  },
  {
    title: 'Land',
    act: 'landingSound',
    tooltip: 'Plays after pod lands',
  },
  {
    title: 'Open',
    act: 'openingSound',
    tooltip: 'Plays when pod opens',
  },
  {
    title: 'Exit',
    act: 'leavingSound',
    tooltip: 'Plays when pod leaves',
  },
];

const STYLES = [
  {
    title: 'Standard',
  },
  {
    title: 'Advanced',
  },
  {
    title: 'Nanotrasen',
  },
  {
    title: 'Syndicate',
  },
  {
    title: 'Deathsquad',
  },
  {
    title: 'Cultist',
  },
  {
    title: 'Missile',
  },
  {
    title: 'Syndie Missile',
  },
  {
    title: 'Supply Box',
  },
  {
    title: 'Clown Pod',
  },
  {
    title: 'Fruit',
  },
  {
    title: 'Invisible',
  },
  {
    title: 'Gondola',
  },
  {
    title: 'Seethrough',
  },
];

const BAYS = [
  {
    title: '1',
  },
  {
    title: '2',
  },
  {
    title: '3',
  },
  {
    title: '4',
  },
  {
    title: 'ERT',
  },
];

const EFFECTS_LOAD = [
  {
    title: 'Launch All Turfs',
    icon: 'globe',
    choiceNumber: 0,
    selected: 'launchChoice',
    act: 'launchAll',
  },
  {
    title: 'Launch Turf Ordered',
    icon: 'sort-amount-down-alt',
    choiceNumber: 1,
    selected: 'launchChoice',
    act: 'launchOrdered',
  },
  {
    title: 'Pick Random Turf',
    icon: 'dice',
    choiceNumber: 2,
    selected: 'launchChoice',
    act: 'launchRandomTurf',
  },
  {
    divider: 1,
  },
  {
    title: 'Launch Whole Turf',
    icon: 'expand',
    choiceNumber: 0,
    selected: 'launchRandomItem',
    act: 'launchWholeTurf',
  },
  {
    title: 'Pick Random Item',
    icon: 'dice',
    choiceNumber: 1,
    selected: 'launchRandomItem',
    act: 'launchRandomItem',
  },
  {
    divider: 1,
  },
  {
    title: 'Clone',
    icon: 'clone',
    soloSelected: 'launchClone',
    act: 'launchClone',
  },
];

const EFFECTS_NORMAL = [
  {
    title: 'Specific Target',
    icon: 'user-check',
    soloSelected: 'effectTarget',
    act: 'effectTarget',
  },
  {
    title: 'Pod Stays',
    icon: 'hand-paper',
    choiceNumber: 0,
    selected: 'effectBluespace',
    act: 'effectBluespace',
  },
  {
    title: 'Stealth',
    icon: 'user-ninja',
    soloSelected: 'effectStealth',
    act: 'effectStealth',
  },
  {
    title: 'Quiet',
    icon: 'volume-mute',
    soloSelected: 'effectQuiet',
    act: 'effectQuiet',
  },
  {
    title: 'Missile Mode',
    icon: 'rocket',
    soloSelected: 'effectMissile',
    act: 'effectMissile',
  },
  {
    title: 'Burst Launch',
    icon: 'certificate',
    soloSelected: 'effectBurst',
    act: 'effectBurst',
  },
  {
    title: 'Any Descent Angle',
    icon: 'ruler-combined',
    soloSelected: 'effectCircle',
    act: 'effectCircle',
  },
  {
    title: 'No Ghost Alert\n(If you dont want to\nentertain bored ghosts)',
    icon: 'ghost',
    choiceNumber: 0,
    selected: 'effectAnnounce',
    act: 'effectAnnounce',
  },
];

const EFFECTS_HARM =[
  {
    title: 'Explosion Custom',
    icon: 'bomb',
    choiceNumber: 1,
    selected: 'explosionChoice',
    act: 'explosionCustom',
  },
  {
    title: 'Adminbus Explosion\nWhat are they gonna do, ban you?',
    icon: 'bomb',
    choiceNumber: 2,
    selected: 'explosionChoice',
    act: 'explosionBus',
  },
  {
    divider: 1,
  },
  {
    title: 'Custom Damage',
    icon: 'skull',
    choiceNumber: 1,
    selected: 'damageChoice',
    act: 'damageCustom',
  },
  {
    title: 'Gib',
    icon: 'skull-crossbones',
    choiceNumber: 2,
    selected: 'damageChoice',
    act: 'damageGib',
  },
  {
    divider: 1,
  },
  {
    title: 'Projectile Cloud',
    details: true,
    icon: 'cloud-meatball',
    soloSelected: 'effectShrapnel',
    act: 'effectShrapnel',
  },
  {
    title: 'Stun',
    icon: 'sun',
    soloSelected: 'effectStun',
    act: 'effectStun',
  },
  {
    title: 'Delimb',
    icon: 'socks',
    soloSelected: 'effectLimb',
    act: 'effectLimb',
  },
  {
    title: 'Yeet Organs',
    icon: 'book-dead',
    soloSelected: 'effectOrgans',
    act: 'effectOrgans',
  },
];
const EFFECTS_ALL = [
  {
    list: EFFECTS_LOAD,
    label: "Load From",
    alt_label: "Load",
    tooltipPosition: "right",
  },
  {
    list: EFFECTS_NORMAL,
    label: "Normal Effects",
    tooltipPosition: "bottom",
  },
  {
    list: EFFECTS_HARM,
    label: "Harmful Effects",
    tooltipPosition: "bottom",
  },
];

const ViewTabHolder = (props, context) => {
  const { act, data } = useBackend(context);
  const [
    tabPageIndex,
    setTabPageIndex,
  ] = useLocalState(context, 'tabPageIndex', 1);
  const { mapRef } = data;
  const TabPageComponent = TABPAGES[tabPageIndex].component();
  return (
    <Section title="View" fill buttons={(
      <Fragment>
        {(!!data.customDropoff && data.effectReverse===1) && (
          <Button
            inline
            color="transparent"
            tooltip="View Dropoff Location"
            icon="arrow-circle-down"
            selected={2 === tabPageIndex}
            onClick={() => {
              setTabPageIndex(2);
              act('tabSwitch', { tabIndex: 2 });
            }} />
        )}
        <Button
          inline
          color="transparent"
          tooltip="View Pod"
          icon="rocket"
          selected={0 === tabPageIndex}
          onClick={() => {
            setTabPageIndex(0);
            act('tabSwitch', { tabIndex: 0 });
          }} />
        <Button
          inline
          color="transparent"
          tooltip="View Source Bay"
          icon="th"
          selected={1 === tabPageIndex}
          onClick={() => {
            setTabPageIndex(1);
            act('tabSwitch', { tabIndex: 1 });
          }} />
        <span style={pod_grey}>|</span>
        {(!!data.customDropoff && data.effectReverse===1) && (
          <Button
            inline
            color="transparent"
            icon="lightbulb"
            selected={data.renderLighting}
            tooltip="Render Lighting for the dropoff view"
            onClick={() => {
              act('renderLighting');
              act('refreshView');
            }}
          />
        )}
        <Button
          inline
          color="transparent"
          icon="sync-alt"
          tooltip="Refresh view window in case it breaks"
          onClick={() => {
            setTabPageIndex(tabPageIndex);
            act('refreshView');
          }}
        />
      </Fragment>
    )}>
      <Flex direction="column" height="100%">
        <Flex.Item m={0.5}>
          <TabPageComponent />
        </Flex.Item>
        <Flex.Item m={0.5} grow={1}>
          <Section fill>
            <ByondUi
              fillPositionedParent
              params={{
                zoom: 0,
                id: mapRef,
                type: 'map',
              }} />
          </Section>
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const TabPod = (props, context) => {
  return (
    <Box color="label">
      Note: You can right click on this
      <br />
      blueprint pod and edit vars directly
    </Box>
  );
};


const TabBay = (props, context) => {
  const { act, data, config } = useBackend(context);
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui/interfaces/CentcomPodLauncher.js
  return (
    <Fragment>
      <Button
        content="Teleport"
        icon="street-view"
        onClick={() => act('teleportCentcom')} />
      <Button
        content={data.oldArea ? data.oldArea.substring(0, 17) : 'Go Back'}
        disabled={!data.oldArea}
        icon="undo-alt"
        onClick={() => act('teleportBack')} />
    </Fragment>
  );
};

const TabDrop = (props, context) => {
  const { act, data, config } = useBackend(context);
  const { mapRef } = data;
  return (
    <Fragment>
      <Button
        content="Teleport"
        icon="street-view"
        onClick={() => act('teleportDropoff')} />
      <Button
        content={data.oldArea ? data.oldArea.substring(0, 17) : 'Go Back'}
        disabled={!data.oldArea}
        icon="undo-alt"
        onClick={() => act('teleportBack')} />
    </Fragment>
  );
};

const PodStatusPage = (props, context) => {
  const { act, data } = useBackend(context);
  const [compact, toggleCompact] = useCompact(context);
  return (
    <Section fill width="100%">
      <Flex>
        {EFFECTS_ALL.map((list, i) => (
          <Fragment key={i}>
            <Flex.Item>
              <Box bold color="label" mb={1}>
                {(compact === 1 && list.alt_label)
                  ? list.alt_label
                  : list.label}:
              </Box>
              <Box>
                {list.list.map((effect, j) => (
                  <Fragment key={j}>
                    {effect.divider && (
                      <span style={pod_grey}><b>|</b></span>
                    )}
                    {!effect.divider &&(
                      <Button
                        tooltip={effect.details
                          ? (data.effectShrapnel
                            ? effect.title
                            +"\n"+data.shrapnelType
                            +"\nMagnitude:"
                            +data.shrapnelMagnitude
                            : effect.title)
                          : effect.title}
                        tooltipPosition={list.tooltipPosition}
                        tooltipOverrideLong
                        icon={effect.icon}
                        content={effect.content}
                        selected={effect.soloSelected
                          ? data[effect.soloSelected]
                          : (data[effect.selected] === effect.choiceNumber)}
                        onClick={() => data.payload !== 0
                          ? act(effect.act, effect.payload)
                          : act(effect.act)}
                        style={{
                          'vertical-align': 'middle',
                          'margin-left': (j !== 0 ? '1px' : '0px'),
                          'margin-right': (
                            j !== list.list.length-1 ? '1px' : '0px'
                          ),
                          'border-radius': '5px',
                        }} />
                    )}
                  </Fragment>
                ))}
              </Box>
            </Flex.Item>
            {i < EFFECTS_ALL.length &&(
              <Flex.Item>
                <Divider vertical />
              </Flex.Item>
            )}
            {i === EFFECTS_ALL.length-1 &&(
              <Flex.Item>
                <Box color="label" mb={1}>
                  <b>Extras:</b>
                </Box>
                <Box>
                  <Button
                    m={0}
                    inline
                    color="transparent"
                    icon="list-alt"
                    tooltip="Game Panel"
                    tooltipPosition="top-left"
                    onClick={() => act('gamePanel')} />
                  <Button
                    inline
                    m={0}
                    color="transparent"
                    icon="hammer"
                    tooltip="Build Mode"
                    tooltipPosition="top-left"
                    onClick={() => act('buildMode')} />
                  {compact && (
                    <Button
                      inline
                      m={0}
                      color="transparent"
                      icon="expand"
                      tooltip="Maximize"
                      tooltipPosition="top-left"
                      onClick={() => {
                        toggleCompact();
                        act('refreshView');
                      }} />
                  ) || (
                    <Button
                      m={0}
                      inline
                      color="transparent"
                      icon="compress"
                      tooltip="Compact mode"
                      tooltipPosition="top-left"
                      onClick={() => toggleCompact()} />
                  )}
                </Box>
              </Flex.Item>
            )}
          </Fragment>
        ))}
      </Flex>
    </Section>
  );
};

const ReverseMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const [
    tabPageIndex,
    setTabPageIndex,
  ] = useLocalState(context, 'tabPageIndex', 1);
  return (
    <Section
      fill
      height="100%"
      title="Reverse"
      buttons={(
        <Button
          icon={data.effectReverse === 1 ? "toggle-on" : "toggle-off"}
          selected={data.effectReverse}
          tooltip={multiline`
            Doesn't send items.
            Afer landing, returns to
            dropoff turf (or bay
            if none specified).`}
          tooltipOverrideLong
          tooltipPosition="top-left"
          onClick={() => {
            act('effectReverse');
            if (tabPageIndex === 2) {
              setTabPageIndex(1);
              act('tabSwitch', { tabIndex: 1 });
            }
          }} />
      )}>
      {data.effectReverse === 1 && (
        <Flex direction="column" height="100%">
          <Flex.Item maxHeight="20px" >
            <Button
              content="Dropoff Turf"
              selected={data.picking_dropoff_turf}
              disabled={!data.effectReverse}
              tooltip={multiline`
                Where reverse pods
                go after landing`}
              tooltipOverrideLong
              tooltipPosition="bottom-right"
              onClick={() => act('pickDropoffTurf')} />
            <Button
              inline
              icon="trash"
              disabled={!data.customDropoff}
              tooltip={multiline`
<<<<<<< HEAD:tgui-next/packages/tgui/interfaces/CentcomPodLauncher.js
                This bay is located on the western edge of CentCom. Its the
                glass room directly west of where ERT spawn, and south of the
                CentCom ferry. Useful for launching ERT/Deathsquads/etc. onto
                the station via drop pods.
              `}
              onClick={() => act('bay5')} />
          </LabeledList.Item>
          <LabeledList.Item label="Teleport to">
=======
                Clears the custom dropoff
                location. Reverse pods will
                instead dropoff at the
                selected bay.`}
              tooltipOverrideLong
              tooltipPosition="bottom"
              onClick={() => {
                act('clearDropoffTurf');
                if (tabPageIndex === 2) {
                  setTabPageIndex(1);
                  act('tabSwitch', { tabIndex: 1 });
                }
              }} />
          </Flex.Item>
          <Divider horizontal />
          <Flex.Item maxHeight="20px">
            {REVERSE_OPTIONS.map((option, i) => (
              <Button
                key={i}
                inline
                icon={option.icon}
                disabled={!data.effectReverse}
                selected={
                  option.key
                    ? data.reverseOptionList[option.key]
                    : data.reverseOptionList[option.title]
                }
                tooltip={option.title}
                tooltipOverrideLong
                onClick={() => act('reverseOption', {
                  reverseOption: option.key
                    ? option.key
                    : option.title })} />
            ))}
          </Flex.Item>
        </Flex>
      )}
    </Section>
  );
};


class PresetsPage extends Component {
  constructor() {
    super();
    this.state = {
      presets: [],
    };
  }

  async componentDidMount() {
    // This warning is generally considered OK to ignore in this context
    // eslint-disable-next-line react/no-did-mount-set-state
    this.setState({
      presets: await this.getPresets(),
    });
  }

  saveDataToPreset(id, data) {
    storage.set("podlauncher_preset_"+id, data);
  }

  async loadDataFromPreset(id, context) {
    const { act, data } = useBackend(context);
    act('loadDataFromPreset', { payload: await storage.get("podlauncher_preset_"+id) });
  }

  newPreset(presetName, hue, data) {
    let { presets } = this.state;
    if (!presets || presets === undefined) {
      presets = [];
      presets.push("hi!");
    }
    let id = createUuid();
    let thing = { id, title: presetName, hue };
    presets.push(thing);
    storage.set("podlauncher_presetlist", presets);
    this.saveDataToPreset(id, data);
  }

  async getPresets() {
    let thing = await storage.get("podlauncher_presetlist");
    if (thing === undefined) {
      thing = [];
    }
    return thing;
  }

  deletePreset(deleteID) {
    const { presets } = this.state;
    for (let i = 0; i < presets.length; i++) {
      if (presets[i].id === deleteID) {
        presets.splice(i, 1);
      }
    }
    storage.set("podlauncher_presetlist", presets);
  }
  render() {
    const { presets } = this.state;
    const { act, data } = useBackend(this.context);
    const [
      presetIndex,
      setSelectedPreset,
    ] = useLocalState(this.context, 'presetIndex', 0);
    const [
      settingName,
      setEditingNameStatus,
    ] = useLocalState(this.context, 'settingName', 0);
    const [newNameText, setText] = useLocalState(this.context, 'newNameText', "");
    const [hue, setHue] = useLocalState(this.context, 'hue', 0);
    return (
      <Section scrollable
        fill
        title="Presets"
        buttons={(
          <Fragment>
            {settingName === 0 && (
              <Button
                color="transparent"
                icon="plus"
                tooltip="New Preset"
                onClick={() => setEditingNameStatus(1)} />
            )}
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui/interfaces/CentcomPodLauncher.js
            <Button
              inline
              color="transparent"
              content=""
              icon="download"
              tooltip="Saves preset"
              tooltipOverrideLong
              tooltipPosition="bottom"
              onClick={() => this.saveDataToPreset(presetIndex, data)} />
            <Button
<<<<<<< HEAD:tgui-next/packages/tgui/interfaces/CentcomPodLauncher.js
              content={data.oldArea ? data.oldArea : 'Where you were'}
              disabled={!data.oldArea}
              onClick={() => act('teleportBack')} />
          </LabeledList.Item>
          <LabeledList.Item label="Clone Mode" >
            <Button
              content="Launch Clones"
              selected={data.launchClone}
              tooltip={multiline`
                Choosing this will create a duplicate of the item to be
                launched in Centcom, allowing you to send one type of item
                multiple times. Either way, the atoms are forceMoved into
                the supplypod after it lands (but before it opens).
              `}
              onClick={() => act('launchClone')} />
          </LabeledList.Item>
          <LabeledList.Item label="Launch style">
            <Button
              content="Ordered"
              selected={data.launchChoice === 1}
              tooltip={multiline`
                Instead of launching everything in the bay at once, this
                will "scan" things (one turf-full at a time) in order, left
                to right and top to bottom. undoing will reset the "scanner"
                to the top-leftmost position.
              `}
              onClick={() => act('launchOrdered')} />
            <Button
              content="Random"
              selected={data.launchChoice === 2}
              tooltip={multiline`
                Instead of launching everything in the bay at once, this
                will launch one random turf of items at a time.
              `}
              onClick={() => act('launchRandom')} />
          </LabeledList.Item>
          <LabeledList.Item label="Explosion">
            <Button
              content="Custom Size"
              selected={data.explosionChoice === 1}
              tooltip={multiline`
                This will cause an explosion of whatever size you like
                (including flame range) to occur as soon as the supplypod
                lands. Dont worry, supply-pods are explosion-proof!
              `}
              onClick={() => act('explosionCustom')} />
            <Button
              content="Adminbus"
              selected={data.explosionChoice === 2}
              tooltip={multiline`
                This will cause a maxcap explosion (dependent on server
                config) to occur as soon as the supplypod lands. Dont worry,
                supply-pods are explosion-proof!
              `}
              onClick={() => act('explosionBus')} />
          </LabeledList.Item>
          <LabeledList.Item label="Damage">
            <Button
              content="Custom Damage"
              selected={data.damageChoice === 1}
              tooltip={multiline`
                Anyone caught under the pod when it lands will be dealt
                this amount of brute damage. Sucks to be them!
              `}
              onClick={() => act('damageCustom')} />
            <Button
              content="Gib"
              selected={data.damageChoice === 2}
              tooltip={multiline`
                This will attempt to gib any mob caught under the pod when
                it lands, as well as dealing a nice 5000 brute damage. Ya
                know, just to be sure!
              `}
              onClick={() => act('damageGib')} />
          </LabeledList.Item>
          <LabeledList.Item label="Effects">
            <Button
              content="Stun"
              selected={data.effectStun}
              tooltip={multiline`
                Anyone who is on the turf when the supplypod is launched
                will be stunned until the supplypod lands. They cant get
                away that easy!
              `}
              onClick={() => act('effectStun')} />
            <Button
              content="Delimb"
              selected={data.effectLimb}
              tooltip={multiline`
                This will cause anyone caught under the pod to lose a limb,
                excluding their head.
              `}
              onClick={() => act('effectLimb')} />
            <Button
              content="Yeet Organs"
              selected={data.effectOrgans}
              tooltip={multiline`
                This will cause anyone caught under the pod to lose all
                their limbs and organs in a spectacular fashion.
              `}
              onClick={() => act('effectOrgans')} />
          </LabeledList.Item>
          <LabeledList.Item label="Movement">
            <Button
              content="Bluespace"
              selected={data.effectBluespace}
              tooltip={multiline`
                Gives the supplypod an advanced Bluespace Recyling Device.
                After opening, the supplypod will be warped directly to the
                surface of a nearby NT-designated trash planet (/r/ss13).
              `}
              onClick={() => act('effectBluespace')} />
            <Button
              content="Stealth"
              selected={data.effectStealth}
              tooltip={multiline`
                This hides the red target icon from appearing when you
                launch the supplypod. Combos well with the "Invisible"
                style. Sneak attack, go!
              `}
              onClick={() => act('effectStealth')} />
            <Button
              content="Quiet"
              selected={data.effectQuiet}
              tooltip={multiline`
                This will keep the supplypod from making any sounds, except
                for those specifically set by admins in the Sound section.
              `}
              onClick={() => act('effectQuiet')} />
            <Button
              content="Reverse Mode"
              selected={data.effectReverse}
              tooltip={multiline`
                This pod will not send any items. Instead, after landing,
                the supplypod will close (similar to a normal closet closing),
                and then launch back to the right centcom bay to drop off any
                new contents.
              `}
              onClick={() => act('effectReverse')} />
            <Button
              content="Missile Mode"
              selected={data.effectMissile}
              tooltip={multiline`
                This pod will not send any items. Instead, it will immediately
                delete after landing (Similar visually to setting openDelay
                & departDelay to 0, but this looks nicer). Useful if you just
                wanna fuck some shit up. Combos well with the Missile style.
              `}
              onClick={() => act('effectMissile')} />
            <Button
              content="Any Descent Angle"
              selected={data.effectCircle}
              tooltip={multiline`
                This will make the supplypod come in from any angle. Im not
                sure why this feature exists, but here it is.
              `}
              onClick={() => act('effectCircle')} />
            <Button
              content="Machine Gun Mode"
              selected={data.effectBurst}
              tooltip={multiline`
                This will make each click launch 5 supplypods inaccuratly
                around the target turf (a 3x3 area). Combos well with the
                Missile Mode if you dont want shit lying everywhere after.
              `}
              onClick={() => act('effectBurst')} />
            <Button
              content="Specific Target"
              selected={data.effectTarget}
              tooltip={multiline`
                This will make the supplypod target a specific atom, instead
                of the mouses position. Smiting does this automatically!
              `}
              onClick={() => act('effectTarget')} />
          </LabeledList.Item>
          <LabeledList.Item label="Name/Desc">
            <Button
              content="Custom Name/Desc"
              selected={data.effectName}
              tooltip="Allows you to add a custom name and description."
              onClick={() => act('effectName')} />
            <Button
              content="Alert Ghosts"
              selected={data.effectAnnounce}
              tooltip={multiline`
                Alerts ghosts when a pod is launched. Useful if some dumb
                shit is aboutta come outta the pod.
              `}
              onClick={() => act('effectAnnounce')} />
          </LabeledList.Item>
          <LabeledList.Item label="Sound">
            <Button
              content="Custom Falling Sound"
              selected={data.fallingSound}
              tooltip={multiline`
                Choose a sound to play as the pod falls. Note that for this
                to work right you should know the exact length of the sound,
                in seconds.
              `}
              onClick={() => act('fallSound')} />
            <Button
              content="Custom Landing Sound"
              selected={data.landingSound}
              tooltip="Choose a sound to play when the pod lands."
              onClick={() => act('landingSound')} />
            <Button
              content="Custom Opening Sound"
              selected={data.openingSound}
              tooltip="Choose a sound to play when the pod opens."
              onClick={() => act('openingSound')} />
            <Button
              content="Custom Leaving Sound"
              selected={data.leavingSound}
              tooltip={multiline`
                Choose a sound to play when the pod departs (whether that be
                delection in the case of a bluespace pod, or leaving for
                centcom for a reversing pod).
              `}
              onClick={() => act('leavingSound')} />
            <Button
              content="Admin Sound Volume"
              selected={data.soundVolume}
              tooltip={multiline`
                Choose the volume for the sound to play at. Default values
                are between 1 and 100, but hey, do whatever. Im a tooltip,
                not a cop.
              `}
              onClick={() => act('soundVolume')} />
          </LabeledList.Item>
          <LabeledList.Item label="Timers">
            <Button
              content="Custom Falling Duration"
              selected={data.fallDuration !== 4}
              tooltip={multiline`
                Set how long the animation for the pod falling lasts. Create
                dramatic, slow falling pods!
              `}
              onClick={() => act('fallDuration')} />
            <Button
              content="Custom Landing Time"
              selected={data.landingDelay !== 20}
              tooltip={multiline`
                Choose the amount of time it takes for the supplypod to hit
                the station. By default this value is 0.5 seconds.
              `}
              onClick={() => act('landingDelay')} />
            <Button
              content="Custom Opening Time"
              selected={data.openingDelay !== 30}
              tooltip={multiline`
                Choose the amount of time it takes for the supplypod to open
                after landing. Useful for giving whatevers inside the pod a
                nice dramatic entrance! By default this value is 3 seconds.
              `}
              onClick={() => act('openingDelay')} />
            <Button
              content="Custom Leaving Time"
              selected={data.departureDelay !== 30}
              tooltip={multiline`
                Choose the amount of time it takes for the supplypod to leave
                after landing. By default this value is 3 seconds.
              `}
              onClick={() => act('departureDelay')} />
          </LabeledList.Item>
          <LabeledList.Item label="Style">
            <Button
              content="Standard"
              selected={data.styleChoice === 1}
              tooltip={multiline`
                Same color scheme as the normal station-used supplypods
              `}
              onClick={() => act('styleStandard')} />
            <Button
              content="Advanced"
              selected={data.styleChoice === 2}
              tooltip={multiline`
                The same as the stations upgraded blue-and-white
                Bluespace Supplypods
              `}
              onClick={() => act('styleBluespace')} />
            <Button
              content="Syndicate"
              selected={data.styleChoice === 4}
              tooltip={multiline`
                A menacing black and blood-red. Great for sending meme-ops
                in style!
              `}
              onClick={() => act('styleSyndie')} />
            <Button
              content="Deathsquad"
              selected={data.styleChoice === 5}
              tooltip={multiline`
                A menacing black and dark blue. Great for sending deathsquads
                in style!
              `}
              onClick={() => act('styleBlue')} />
            <Button
              content="Cult Pod"
              selected={data.styleChoice === 6}
              tooltip="A blood and rune covered cult pod!"
              onClick={() => act('styleCult')} />
            <Button
              content="Missile"
              selected={data.styleChoice === 7}
              tooltip={multiline`
                A large missile. Combos well with a missile mode, so the
                missile doesnt stick around after landing.
              `}
              onClick={() => act('styleMissile')} />
            <Button
              content="Syndicate Missile"
              selected={data.styleChoice === 8}
              tooltip={multiline`
                A large blood-red missile. Combos well with missile mode,
                so the missile doesnt stick around after landing.
              `}
              onClick={() => act('styleSMissile')} />
            <Button
              content="Supply Crate"
              selected={data.styleChoice === 9}
              tooltip="A large, dark-green military supply crate."
              onClick={() => act('styleBox')} />
            <Button
              content="HONK"
              selected={data.styleChoice === 10}
              tooltip="A colorful, clown inspired look."
              onClick={() => act('styleHONK')} />
            <Button
              content="~Fruit"
              selected={data.styleChoice === 11}
              tooltip="For when an orange is angry"
              onClick={() => act('styleFruit')} />
            <Button
              content="Invisible"
              selected={data.styleChoice === 12}
              tooltip={multiline`
                Makes the supplypod invisible! Useful for when you want to
                use this feature with a gateway or something. Combos well
                with the "Stealth" and "Quiet Landing" effects.
              `}
              onClick={() => act('styleInvisible')} />
            <Button
              content="Gondola"
              selected={data.styleChoice === 13}
              tooltip={multiline`
                This gondola can control when he wants to deliver his supplies
                if he has a smart enough mind, so offer up his body to ghosts
                for maximum enjoyment. (Make sure to turn off bluespace and
                set a arbitrarily high open-time if you do!
              `}
              onClick={() => act('styleGondola')} />
            <Button
              content="Show Contents (See Through Pod)"
              selected={data.styleChoice === 14}
              tooltip={multiline`
                By selecting this, the pod will instead look like whatevers
                inside it (as if it were the contents falling by themselves,
                without a pod). Useful for launching mechs at the station
                and standing tall as they soar in from the heavens.
              `}
              onClick={() => act('styleSeeThrough')} />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section>
        <LabeledList>
          <LabeledList.Item
            label={data.numObjects + ' turfs in ' + data.bay}
            buttons={(
              <Fragment>
                <Button
                  content="undo Pody Bay"
                  tooltip={multiline`
                    Manually undoes the possible things to launch in the
                    pod bay.
                  `}
                  onClick={() => act('undo')} />
                <Button
                  content="Enter Launch Mode"
                  selected={data.giveLauncher}
                  tooltip="THE CODEX ASTARTES CALLS THIS MANEUVER: STEEL RAIN"
                  onClick={() => act('giveLauncher')} />
                <Button
                  content="Clear Selected Bay"
                  color="bad"
                  tooltip={multiline`
                    This will delete all objs and mobs from the selected bay.
                  `}
                  tooltipPosition="left"
                  onClick={() => act('clearBay')} />
              </Fragment>
            )} />
        </LabeledList>
=======
              inline
              color="transparent"
              content=""
              icon="upload"
              tooltip="Loads preset"
              onClick={() => { // Line break to meet line length reqs
                this.loadDataFromPreset(presetIndex, this.context);
              }} />
            <Button
              inline
              color="transparent"
              icon="trash"
              tooltip="Deletes the selected preset"
              tooltipPosition="bottom-left"
              onClick={() => this.deletePreset(presetIndex)} />
          </Fragment>)}>
        {settingName === 1 && (
          <Fragment>
            <Button
              inline
              icon="check"
              tooltip="Confirm"
              tooltipPosition="right"
              onClick={() => {
                this.newPreset(newNameText, hue, data);
                setEditingNameStatus(0);
              }} />
            <Button
              inline
              icon="window-close"
              tooltip="Cancel"
              onClick={() => {
                setText("");
                setEditingNameStatus(0);
              }} />
            <span color="label"> Hue: </span>
            <NumberInput
              inline
              animated
              width="40px"
              step={5}
              stepPixelSize={5}
              value={hue}
              minValue={0}
              maxValue={360}
              onChange={(e, value) => setHue(value)} />
            <Input
              inline
              autofocus
              placeholder="Preset Name"
              onChange={(e, value) => setText(value)} />
            <Divider horizontal />
          </Fragment>
        )}
        {(!presets || presets.length === 0) && (
          <span style={pod_grey}>
            Click [+] to define a new preset.
            They are persistent across rounds/servers!
          </span>
        )}
        {presets ? presets.map((preset, i) => (
          <Button
            key={i}
            width="100%"
            backgroundColor={`hsl(${preset.hue}, 50%, 50%)`}
            onClick={() => setSelectedPreset(preset.id)}
            content={preset.title}
            style={presetIndex === preset.id ? {
              'border-width': '1px',
              'border-style': 'solid',
              'border-color': `hsl(${preset.hue}, 80%, 80%)`,
            } : ''} />
        )) : ""}
        <span style={pod_grey}>
          <br />
          <br />
          NOTE: Custom sounds from outside the base game files will not save! :(
        </span>
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui/interfaces/CentcomPodLauncher.js
      </Section>
    );
  }
}

const LaunchPage = (props, context) => {
  const [compact] = useCompact(context);
  const { act, data } = useBackend(context);
  return (
    <Button
      fluid
      textAlign="center"
      tooltip={multiline`
        You should know what the
        Codex Astartes says about this`}
      tooltipOverrideLong
      selected={data.giveLauncher}
      tooltipPosition="top"
      content={(
        <Box
          bold
          fontSize="1.4em"
          lineHeight={compact ? 1.5 : 3}>
          LAUNCH
        </Box>
      )}
      onClick={() => act('giveLauncher')}
    />
  );
};

const StylePage = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section
      fill
      scrollable
      title="Style"
      buttons={(
        <Button
          content="Name"
          color="transparent"
          icon="edit"
          selected={data.effectName}
          tooltip={multiline`
            Edit pod's
            name/desc.`}
          tooltipPosition="bottom-left"
          onClick={() => act('effectName')} />
      )}>
      {STYLES.map((page, i) => (
        <Button
          key={i}
          width="45px"
          height="45px"
          tooltipPosition={
            i >= STYLES.length-2
              ? (i%2===1 ? "top-left" : "top-right")
              : (i%2===1 ? "bottom-left" : "bottom-right")
          }
          tooltip={page.title}
          style={{
            'vertical-align': 'middle',
            'margin-right': '5px',
            'border-radius': '20px',
          }}
          selected={data.styleChoice-1 === i}
          onClick={() => act('setStyle', { style: i })}>
          <Box
            className={classes(['supplypods64x64', 'pod_asset'+(i+1)])}
            style={{
              'transform': 'rotate(45deg) translate(-25%,-10%)', 'pointer-events': 'none',
            }} />
        </Button>
      ))}
    </Section>
  );
};

const Bays = (props, context) => {
  const { act, data } = useBackend(context);
  const [compact] = useCompact(context);
  return (
    <Section
      fill
      title="Bay"
      buttons={(
        <Fragment>
          <Button
            icon="trash"
            color="transparent"
            tooltip={multiline`
              Clears everything
              from the selected bay`}
            tooltipOverrideLong
            tooltipPosition="bottom-right"
            onClick={() => act('clearBay')} />
          <Button
            icon="question"
            color="transparent"
            tooltip={multiline`
              Each option corresponds
              to an area on centcom.
              Launched pods will
              be filled with items
              in these areas according
              to the "Load from Bay"
              options at the top left.`}
            tooltipOverrideLong
            tooltipPosition="bottom-right" />
        </Fragment>
      )}>
      {BAYS.map((bay, i) => (
        <Button
          key={i}
          content={bay.title}
          tooltipPosition={"bottom-right"}
          selected={data.bayNumber === ""+(i+1)}
          onClick={() => act('switchBay', { bayNumber: (""+(i+1)) })} />
      ))}
    </Section>
  );
};

const Timing = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Section
      fill
      title="Delay"
      buttons={(
        <Button
          icon="undo"
          color="transparent"
          tooltip={multiline`
            Reset all pod
            timings/delays`}
          tooltipOverrideLong
          tooltipPosition="bottom-right"
          onClick={() => act('resetTiming')} />
      )}>
      <LabeledControls wrap>
        {DELAYS.map((delay, i) => (
          <LabeledControls.Item
            key={i}
            label={delay.title}>
            <Knob
              inline
              step={0.02}
              value={data["delay_"+(i+1)]/10}
              unclamped
              minValue={0}
              unit={"s"}
              format={value => toFixed(value, 2)}
              maxValue={10}
              color={(data["delay_"+(i+1)]/10) > 10 ? "orange" : "default"}
              onDrag={(e, value) => {
                act('editTiming', {
                  timer: i + 1,
                  value: Math.max(value, 0),
                });
              }} />
          </LabeledControls.Item>
        ))}
      </LabeledControls>
    </Section>
  );
};

const Sounds = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section fill title="Sounds"
      buttons={(
        <Button
          icon="volume-up"
          color="transparent"
          selected={data.soundVolume !== data.defaultSoundVolume}
          tooltip={multiline`
            Sound Volume:` + data.soundVolume}
          tooltipOverrideLong
          onClick={() => act('soundVolume')} />
      )}>
      {SOUNDS.map((sound, i) => (
        <Button
          key={i}
          content={sound.title}
          tooltip={sound.tooltip}
          tooltipPosition="top-right"
          tooltipOverrideLong
          selected={data[sound.act]}
          onClick={() => act(sound.act)} />
      ))}
    </Section>
  );
};
